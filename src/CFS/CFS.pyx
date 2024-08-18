from CFS import routines, constants
from pathlib import Path
import array
import cython
from cython.cimports.cpython import array

@cython.cclass
class CFSFile:
    date = cython.declare(bytes, visibility = 'readonly')
    time = cython.declare(bytes, visibility = 'readonly')
    comment = cython.declare(bytes, visibility = 'readonly')

    channel_data = cython.declare(list[list], visibility = 'readonly')
    channel_info = cython.declare(list[dict], visibility = 'readonly')
    file_variables = cython.declare(list, visibility = 'readonly')

    def __init__(self, filename: bytes):
        file_handle = routines.open_cfs_file(filename)
        channel_count, file_variable_count, data_section_variable_count, data_section_count = routines.get_file_info(file_handle)
        self.time, self.date, self.comment = routines.get_gen_info(file_handle)

        self.channel_info = []
        self.channel_data = []

        current_channel: cython.int = 0
        for current_channel in range(channel_count):
            current_channel_name, current_y_units, current_x_units, current_data_type, current_data_kind, spacing, other = routines.get_file_chan(file_handle, current_channel)
            current_channel_info = {
                    "name": current_channel_name,
                    "y_units": current_y_units,
                    "x_units": current_x_units
                    }
            self.channel_info.append(current_channel_info)

            self.channel_data.append([])

            current_data_section: cython.int = 0
            for current_data_section in range(data_section_count):

                _, points, current_y_scale, current_y_offset, current_x_scale, current_x_offset = routines.get_ds_chan(file_handle, current_channel, current_data_section)

                current_data = routines.get_chan_data(file_handle, current_channel, current_data_section, 0, points, current_data_type)

                float_array_template = cython.declare(array.array, array.array('f', []))
                cython.declare(current_scaled_data = array.array)
                current_scaled_data = array.clone(float_array_template, len(current_data), zero=True)
                current_point: cython.int = 0
                for current_point in range(len(current_data)):
                    current_scaled_data[current_point] = (current_data[current_point] + current_y_offset) * current_y_scale
                self.channel_data[current_channel].append(current_scaled_data)

        routines.close_cfs_file(file_handle)
