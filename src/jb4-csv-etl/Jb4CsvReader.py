import csv
from operator import eq
from random import sample
import time
from Jb4DataModels import Jb4Parameters, Jb4DataSample

NANO_SECONDS = 1,000,000,000

class Jb4CsvReader:
    def __init__(self, f, base_time_ns: int = -1):
        self._file = f
        self._parameters = None
        self._sample_reader = None
        if base_time_ns is -1:
            self._base_time_ns = time.time_ns()

    def __iter__(self):
        return self

    @property
    def parameters(self):
        if self._parameters is None:
            # Read JB4 Parameters part 1
            part1 = csv.DictReader(self._file)
            params_dict1 = next(part1)
            # Read JB4 Parameters part 2
            part2 = csv.DictReader(self._file)
            params_dict2 = next(part2)
            combined = params_dict1 | params_dict2
            self._parameters = Jb4Parameters(**combined)
        return self._parameters

    @parameters.setter
    def parameters(self, value):
        self._parameters = value

    def __next__(self):
        if self._parameters is None:
            # Used only for its side effect.
            self.parameters

        if self._sample_reader is None:
            self._sample_reader = csv.DictReader(self._file)

        sample_dict = next(self._sample_reader)
        sample_obj = Jb4DataSample(**sample_dict)

        # JB4 CSV timestamps are in units of 1/10 seconds, this
        # adjusts the unit to seconds and then uses adds it
        # to _base_time_ns. We do this so that our sample data
        # can be correlated with specific days and times, while 
        # maintaining the correct frequency of the samples.
        sample_obj.timestamp_ns = self._base_time_ns
        if sample_obj.timestamp_raw > 0:
            sample_obj.timestamp_raw /= 10
            # Convert timestamp_raw from sec to ns and add to timestamp_ns
            sample_obj.timestamp_ns += int(sample_obj.timestamp_raw * (10**9))
        return sample_obj