import cython
from cython.cimports.CFS import api

@cython.ccall
def open_cfs_file(filename: cython.p_char) -> api.cfs_short:
    handle = api.OpenCFSFile(filename, 0, 1)
    if handle < 0:
        raise Exception("Invalid File Handle")
    return handle

@cython.ccall
def close_cfs_file(handle: api.cfs_short):
    api.CloseCFSFile(handle)
