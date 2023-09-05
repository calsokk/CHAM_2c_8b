#pragma once

#include <arpa/inet.h>
#include <netinet/tcp.h>
#include <sys/socket.h>
#include <unistd.h>

#include <random>
#include <vector>

// Mimic network transfer
struct LocalLoopIO {
  static constexpr size_t NETWORK_BUFFER_SIZE = 1UL << 20;

  bool is_server;
  int mysocket = -1;
  int consocket = -1;
  FILE *stream = nullptr;
  char *buffer = nullptr;
  bool has_sent = false;
  int port;

  explicit LocalLoopIO(bool is_server, int port) {
    this->port = port;
    this->is_server = is_server;
    if (is_server) {
      struct sockaddr_in dest;
      struct sockaddr_in serv;
      socklen_t socksize = sizeof(struct sockaddr_in);
      memset(&serv, 0, sizeof(serv));
      serv.sin_family = AF_INET;
      serv.sin_addr.s_addr = htonl(INADDR_ANY);
      /* set our address to any interface */
      serv.sin_port = htons(port); /* set the server port number */
      mysocket = socket(AF_INET, SOCK_STREAM, 0);
      int reuse = 1;
      setsockopt(mysocket, SOL_SOCKET, SO_REUSEADDR, (const char *)&reuse,
                 sizeof(reuse));

      if (bind(mysocket, (struct sockaddr *)&serv, sizeof(struct sockaddr)) <
          0) {
        perror("error: bind");
        exit(1);
      }

      if (listen(mysocket, 1) < 0) {
        perror("error: listen");
        exit(1);
      }

      consocket = accept(mysocket, (struct sockaddr *)&dest, &socksize);
      close(mysocket);
    } else {
      struct sockaddr_in dest;
      std::memset(&dest, 0, sizeof(dest));
      dest.sin_family = AF_INET;
      const char *addr = "127.0.0.1";  // local-loop
      dest.sin_addr.s_addr = inet_addr(addr);
      dest.sin_port = htons(port);

      while (1) {
        consocket = socket(AF_INET, SOCK_STREAM, 0);

        if (connect(consocket, (struct sockaddr *)&dest,
                    sizeof(struct sockaddr)) == 0) {
          break;
        }

        close(consocket);
        usleep(1000);
      }
    }

    stream = fdopen(consocket, "wb+");
    buffer = new char[NETWORK_BUFFER_SIZE];
    memset(buffer, 0, NETWORK_BUFFER_SIZE);
    //  fully buffered I/O
    setvbuf(stream, buffer, _IOFBF, NETWORK_BUFFER_SIZE);
    set_nodelay();
    std::cout << "LocalLoopIO connected" << std::endl;
  }

  ~LocalLoopIO() { delete[] buffer; }

  void set_nodelay() {
    const int one = 1;
    setsockopt(consocket, IPPROTO_TCP, TCP_NODELAY, &one, sizeof(one));
  }

  void set_delay() {
    const int zero = 0;
    setsockopt(consocket, IPPROTO_TCP, TCP_NODELAY, &zero, sizeof(zero));
  }

  void flush() { fflush(stream); }

  bool send_data(const uint8_t *data, size_t len) {
    size_t sent = 0;
    while (sent < len) {
      int res = fwrite(data + sent, 1, len - sent, stream);
      if (res >= 0) {
        sent += res;
      } else {
        fprintf(stderr, "error: net_send_data %d\n", res);
        return false;
      }
    }
    has_sent = true;
    return true;
  }

  bool recv_data(uint8_t *data, size_t len) {
    if (has_sent) fflush(stream);
    has_sent = false;
    size_t sent = 0;
    while (sent < len) {
      int res = fread(data + sent, 1, len - sent, stream);
      if (res >= 0) {
        sent += res;
      } else {
        fprintf(stderr, "error: net_send_data %d\n", res);
        return false;
      }
    }
    return true;
  }

  void send_strings(const std::vector<std::string> &strs) {
    uint32_t num_str = strs.size();
    send_data((const uint8_t *)&num_str, sizeof(uint32_t));

    if (num_str > 0) {
      for (const auto &s : strs) {
        uint32_t len = s.length();
        send_data((const uint8_t *)&len, sizeof(uint32_t));
        send_data((const uint8_t *)s.c_str(), len);
      }
    }
  }

  void recv_strings(std::vector<std::string> &out) {
    uint32_t num_str;
    recv_data((uint8_t *)&num_str, sizeof(uint32_t));
    if (num_str > 128) {
      throw std::runtime_error("recv_strings: num_str out-of-bound");
    }

    if (num_str > 0) {
      out.resize(num_str);
      std::vector<char> buffer(1024 * 1024 * 10);  // 10MB
      for (size_t i = 0; i < num_str; ++i) {
        uint32_t len;
        recv_data((uint8_t *)&len, sizeof(uint32_t));
        if (len > buffer.size()) {
          throw std::runtime_error("recv_strings: len out-of-bound");
        }
        recv_data((uint8_t *)buffer.data(), len);
        out[i] = std::string(buffer.data(), buffer.data() + len);
      }
    }
  }
};

// r -> round(r*2^p) mod 2^64
inline uint64_t RealToU64(double r, int precision) {
  return static_cast<int64_t>(std::roundf(r * (1ULL << precision)));
}

inline double U64ToReal(uint64_t r, int precision) {
  return static_cast<int64_t>(r) / std::pow(2., precision);
}

// share0 + share1 mod 2^64 = round(real * 2^precision)
inline void ShareToU64(const std::vector<double> &reals, const int precision,
                       std::vector<uint64_t> &share0,
                       std::vector<uint64_t> &share1) {
  size_t n = reals.size();
  if (n == 0) return;
  share0.resize(n);
  share1.resize(n);

  // (NOTE): Use fixed seed in demo.
  std::mt19937 rdv(646435);
  // sample from [0, 2^64)
  std::uniform_int_distribution<uint64_t> uniform(0, static_cast<uint64_t>(-1));
  std::generate_n(share1.begin(), n, [&]() { return uniform(rdv); });

  for (size_t i = 0; i < n; ++i) {
    uint64_t x = RealToU64(reals[i], precision);
    share0[i] = x - share1[i];
  }
}

inline void RandomReal(std::vector<double> &reals, size_t n,
                       double upper = 1.) {
  // (NOTE): Use fixed seed in demo.
  std::mt19937 rdv(354145);
  upper = std::abs(upper);
  std::uniform_real_distribution<double> uniform(-upper, upper);
  reals.resize(n);
  std::generate_n(reals.begin(), n, [&]() { return uniform(rdv); });
}

inline size_t TotalKiloBytes(const std::vector<std::string> &strs) {
  size_t kb = std::accumulate(
      strs.begin(), strs.end(), 0,
      [](size_t init, const std::string &in) { return init + in.length(); });
  return kb >> 10;
}
