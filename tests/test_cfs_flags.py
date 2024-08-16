from CFS.api import CFSFlag

def test_cfs_flags():
    assert CFSFlag.flag_7 == 1
    assert CFSFlag.flag_6 == 2
    assert CFSFlag.flag_5 == 4
    assert CFSFlag.flag_4 == 8
    assert CFSFlag.flag_3 == 16
    assert CFSFlag.flag_2 == 32
    assert CFSFlag.flag_1 == 64
    assert CFSFlag.flag_0 == 128
    assert CFSFlag.flag_15 == 256
    assert CFSFlag.flag_14 == 512
    assert CFSFlag.flag_13 == 1024
    assert CFSFlag.flag_12 == 2048
    assert CFSFlag.flag_11 == 4096
    assert CFSFlag.flag_10 == 8192
    assert CFSFlag.flag_9 == 16384
    assert CFSFlag.flag_8 == 32768
    assert CFSFlag.no_flags == 0
