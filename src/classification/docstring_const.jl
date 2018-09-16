const SCALAR_DESC = """
    Typically both parameters are arrays of some form, (e.g.
    vectors or row-vectors), but its also possible to provide a
    single obseration as "scalar" value.
    """

const COUNT_ARGS = """
    - `targets`: Either an array of multiple ground truths
      ``\\mathbf{y}``, or a single ground truth ``y``.

    - `outputs`: Either an array of multiple predicted outputs
      ``\\mathbf{\\hat{y}}``, or a single prediction ``\\hat{y}``.

    - `encoding`: Optional. Specifies the possible labels/value
      in `targets` and `outputs` and their interpretation (e.g.
      what constitutes as positive or negative, how many classes
      exist, etc). It can either be an object from the namespace
      `LabelEnc`, or a vector of labels.
    """

const ENCODING_DESCR = """
    The return value of the function depends on the number of
    labels in the given `encoding`. In case the `encoding` is
    binary (i.e. it has exactly 2 labels), a single integer value
    is returned. Otherwise, the function will compute a separate
    result for each individual label, where that label is treated
    as "positive" and the other labels are treated as "negative".
    These results are then returned as a single dictionary with
    an entry for each label.

    If `encoding` is omitted, the appropriate
    `MLLabelUtils.LabelEncoding` will be inferred from the types
    and/or values of `targets` and `outputs`. Note that omitting
    the `encoding` can cause performance penalties, which may
    include a lack of return-type inference.
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
