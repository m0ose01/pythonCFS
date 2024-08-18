from CFS import routines, constants
from pathlib import Path
import array
import cython
from cython.cimports.cpython import array

@cython.ccall
def load_cfs(filename: bytes) -> list[array.array]:
    file_handle = routines.open_cfs_file(filename)
    print(file_handle)

    channel_count, file_variable_count, data_section_variable_count, data_section_count = routines.get_file_info(file_handle)

    time, date, comment = routines.get_gen_info(file_handle)
    message = (
            f"File: {filename}\n"
            f"Created on {date} at {time}\n"
            f"Comment: {comment}\n"
            f"{channel_count} channels, {file_variable_count} file variables, {data_section_variable_count} data section vars, {data_section_count} data sections."
            )
    print(message)

    data = []

    current_channel: cython.int = 0
    for current_channel in range(channel_count):
        current_channel_name, current_y_units, current_x_units, current_data_type, current_data_kind, spacing, other = routines.get_file_chan(file_handle, current_channel)
        print(current_channel_name)
        current_data_section: cython.int = 0
        for current_data_section in range(data_section_count):

            _, points, current_y_scale, current_y_offset, current_x_scale, current_x_offset = routines.get_ds_chan(file_handle, current_channel, current_data_section)

            current_data = routines.get_chan_data(file_handle, current_channel, current_data_section, 0, points, current_data_type)
            data.append(current_data)

    routines.close_cfs_file(file_handle)
    return data
