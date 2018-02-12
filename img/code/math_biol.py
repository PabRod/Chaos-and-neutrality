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

def import_timeseries(filename):
    import scipy.io as sio

    dict = sio.loadmat(filename)
    y_out = dict['y_out']
    t_out = dict['t_out']

    return (y_out, t_out)

def import_contour(filename):
    import scipy.io as sio

    dict = sio.loadmat(filename)
    competition_pars = dict['competition_pars']
    nSpecies = dict['nSpecies']
    summaries = dict['summaries']
    levels = dict['levels']

    return (competition_pars, nSpecies, summaries, levels)


def plot_imported_timeseries(filename):
    import matplotlib as plt
    
    (y_out, t_out) = import_timeseries(filename)

    plt.plot(t_out, y_out)
