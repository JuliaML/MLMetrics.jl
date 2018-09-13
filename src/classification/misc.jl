const ENCODING_DESCR = """
    The optional parameter `encoding` serves as specifcation of
    the existing labels and their interpretation (e.g. what
    constitutes as positive or negative, how many classes exist, etc).
    It can either be an object from the namespace `LabelEnc`, or
    a vector of labels. If omitted, the appropriate `encoding`
    will be inferred from the types and/or values of `targets`
    and `outputs`. Note that omitting the `encoding` can cause
    performance penalties, which may include a lack of type stability.
    """

const AVGMODE_DESCR = """
    The optional (keyword) parameter `avgmode` can be used to
    specify if and how class-specific results should be
    aggregated. This is mainly useful if there are more than two
    classes. Typical values are `:none` (default), `:micro` for
    micro averaging, or `:macro` for macro averaging. It is also
    possible to specify `avgmode` as a type-stable positional
    argument using an object from the `AvgMode` namespace.
    """
