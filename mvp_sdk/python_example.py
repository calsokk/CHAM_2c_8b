import numpy as np
import timeit
import pickle
from build.lib._mvp_py.mvp import MVPProtocol

# Auth
a_prot = MVPProtocol()
a_prot.activate(gen_secret_key=True)
a_evk = pickle.dumps(a_prot.gen_eval_keys(), 2)

# Host
h_prot = MVPProtocol()
h_prot.activate(gen_secret_key=False)
h_prot.setup_eval_keys(pickle.loads(a_evk))

# Guest
g_prot = MVPProtocol()
g_prot.activate(gen_secret_key=False)
g_prot.setup_eval_keys(pickle.loads(a_evk))

## We compute mat*(vec0 + vec1) - 0.1*w for private vec0 and vec1

### Prepare the data
nrows, ncols = 127, 121
vec0 = np.random.randn(ncols)
vec1 = np.random.randn(ncols)
mat = np.random.randn(nrows * ncols)
w = np.random.randn(nrows)

# Host encrypt vec0 and sends the ciphertext to Guest
enc_vec0 = h_prot.encrypt_vector(vec0)

# Guest adds [vec0] with vec1, then compute the mat-vec
enc_vec_add = g_prot.add_vector(vec1, enc_vec0)
enc_matvec = g_prot.matvec(mat, enc_vec_add, [nrows, ncols])
# Finally Guest update the matvec
updated = g_prot.update_vector(-w*0.1, enc_matvec)

# Guest send the ciphertext `updated` to Auth for decryption
result = a_prot.decrypt(updated)
mat_2d = mat.reshape([nrows, ncols])
ground = mat_2d.dot(vec0 + vec1) - 0.1*w

print("max error {}".format(np.max(np.abs(result - ground))))
