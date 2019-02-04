from inspect import getcallargs


class Event(object):
    """
    A class that can register callbacks and call them when an event happens
    """

    def __init__(self, cb_args=1):
        """
        Construct an Event object

        :param cb_args: Specifying an integer value will check that callbacks
        take the correct number of arguments when they connect.  Specifying
        an array of types will check that callbacks take the correct number of
        arguments when they connect AND that callers provide the correct types
        when invoking the callbacks.
        """
        if isinstance(cb_args, list):
            self._dummy_args = cb_args
        else:
            if isinstance(cb_args, int):
                self._dummy_args = [
                                       None] * cb_args
            else:
                raise TypeError('cb_args must be a list of types, or an integer value')
        self._cbs = []
        return

    def connect(self, cb):
        """
        Connect a callback function that will be called when the event is
        is raised

        connect will verify that the callback function takes the correct
        number of arguments (as specified to the Event constructor) and raise
        a TypeError if the callback function's signature is not correct

        :param cb: A callback function.
        """
        try:
            getcallargs(cb, *self._dummy_args)
        except TypeError as e:
            raise TypeError('Callback does not match the signature of the Event. ' + e.message)

        self._cbs.append(cb)

    def disconnect(self, cb):
        """
        Disconnects a callback function that was previously connected

        :param cb: The function to disconnect
        """
        if self.is_connected(cb):
            self._cbs.remove(cb)

    def is_connected(self, cb):
        """
        Determines if a callback is connected or not
        """
        return cb in self._cbs

    def __call__(self, *args, **kwargs):
        if len(args) != len(self._dummy_args):
            raise TypeError('Too many arguments specified')
        for arg, spec_type in zip(args, self._dummy_args):
            if spec_type is None:
                continue
            elif isinstance(arg, spec_type):
                continue
            else:
                raise TypeError(('{} is not an instance of {}').format(arg, spec_type))

        for cb in self._cbs:
            cb(*args, **kwargs)

        return