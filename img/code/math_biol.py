import numpy as np

def competition(y, t, r, K, A):
    dydt = np.dot(r, y) * (1 - np.dot(A, y))
    return dydt

def competition_matrix(N, p, mode='stretching_window', w=0.1):

    if mode == 'stretching_window':
        A = np.ones(N) + p * np.random.rand(N, N)
        np.fill_diagonal(A, 1)

        return A
    elif mode == 'sliding_window':
        A = np.ones(N) + p + w * (np.random.rand(N, N) - 0.5)
        np.fill_diagonal(A, 1)

        return A
    else:
        error()
