"""
Implementation of clustering metrics based on the following papers:

A. Rosenberg and J. Hirschberg, (2007). V-Measure: A conditional
entropy-based external cluster evaluation measure

L. Hubert and P. Arabie, (1985). Comparing Partitions,  Journal of
Classification

Vinh, Epps, and Bailey, (2010). Information Theoretic Measures
for Clusterings Comparison: Variants, Properties, Normalization
and Correction for Chance, JMLR
"""
# ============================================================
immutable ContingencyTable
    N::Int
    R::Int
    C::Int
    a::Array{Int}
    b::Array{Int}
    n::Array{Int,2}
    function ContingencyTable(U::AbstractVector,
                              V::AbstractVector)
    @_dimcheck length(U) == length(V)
    N = length(U)
    U_clusters = collect(Set(U))
    V_clusters = collect(Set(V))
    R = length(U_clusters)
    C = length(V_clusters)
    n = zeros(Int64, R, C)
    for i = 1:R
        for j = 1:C
            n[i, j] = number_of_intersection(U_clusters[i], U, V_clusters[j], V)
        end
    end
    a = reshape(sum(n, 2), R)
    b = reshape(sum(n, 1), C)
    new(N, R, C, a, b, n)
    end
end

"""
    number_of(item, list)
number_of returns the number of the item in the list
"""
function number_of(item::Any,
                  list::AbstractVector)
    length(find(list .== item))
end

"""
    number_of_intersection(item_1, list_1, item_2, list_2)
NumberOfIntersection returns the number of items in the intersection
of first item in the first liat and second item in the second list.
"""
function number_of_intersection(item_1::Any,
                                list_1::AbstractVector,
                                item_2::Any,
                                list_2::AbstractVector)
    logic_1 = item_1 .== list_1
    logic_2 = item_2 .== list_2
    length(find(logic_1 + logic_2 .== 2))
end

"""
    entropy(U)
entropy(U) returns the entropy of clustering 'U'.
"""
function entropy(U::AbstractVector)
    result = 0
    N = length(U)
    clusters = Set(U)
    for c in clusters
        a = number_of(c, U)
        result += (a / N) * log(a / N)
    end
    -result
end

"""
    entropy(U, V)
entropy(U, V) returns the joint entropy of clusterings 'U' and 'V'.
"""
function entropy(U::AbstractVector,
                 V::AbstractVector)
    result = 0
    table = ContingencyTable(U, V)
    N = table.N
    for i = 1 : table.R
        for j = 1 : table.C
            n = table.n[i, j]
            if n != 0
                result += (n / N) * log(n / N)
            end
        end
    end
    -result
end

"""
    entropy_conditional(U, V)
entropy_conditional(U, V) returns the conditional entropy
of clusterings U given V.
"""
function entropy_conditional(U::AbstractVector,
                             V::AbstractVector)
    result = 0
    table = ContingencyTable(U, V)
    N = table.N
    a = table.a
    b = table.b
    n = table.n
    for i = 1:table.R
        for j = 1:table.C
            if n[i,j] != 0
                result += (n[i,j]/N) * log(n[i,j]/b[j])
            end
        end
    end
    -result
end

# ============================================================
"""
    mutual_info_score(target, output)
The Mutual Information is a measure of the similarity and the mutual
dependence between two labels or clusters of the same data.
"""
function mutual_info_score(target::AbstractVector,
                           output::AbstractVector)
    result = 0
    table = ContingencyTable(target, output)
    for i = 1:table.R
        for j = 1:table.C
            intersection_number = table.n[i, j]
            true_number = table.a[i]
            pred_number = table.b[j]
            N = table.N
            temp = (intersection_number / N) *
                   log(N * intersection_number / (true_number * pred_number))
            if !isnan(temp)
                  result += temp
            end
        end
    end
    result
end

"""
    normalized_mutual_info_score(target, output, mode)
normalized_mutual_info_score computes mutual information but it limits the range of the
return value from 0 (no similarity) to 1 (completely similar). There are
five different approaches introduced by Vinh et al. (2010), that they can
be selected by 'mode' argument.
"""
function normalized_mutual_info_score(target::AbstractVector,
                                      output::AbstractVector,
                                      mode::AbstractString = "sqrt")
    result = 0
    if mode == "sqrt"
        denominator = sqrt(entropy(target) * entropy(output))
        if denominator == 0
            result = 0.0
        else
            result = mutual_info_score(target, output) /
                     denominator
        end
    elseif mode == "max"
        denominator = max(entropy(target), entropy(output))
        if denominator == 0
            result = 0.0
        else
            result = mutual_info_score(target, output) /
                     denominator
        end
    elseif mode == "min"
        denominator = min(entropy(target), entropy(output))
        if denominator == 0
            result = 0.0
        else
            result = mutual_info_score(target, output) /
                     denominator
        end
    elseif mode == "sum"
        denominator = entropy(target) + entropy(output)
        if denominator == 0
            result = 0.0
        else
            result = 2 * mutual_info_score(target, output) /
                     denominator
        end
    elseif mode == "joint"
        denominator = entropy(target, output)
        if denominator == 0
            result = 0.0
        else
            result = mutual_info_score(target, output) /
                     denominator
        end
    else
        throw(DomainError())
    end
    result
end

"""
    expected_mutual_informatio(target, output)
expected_mutual_informatio returns the expected value of mutual
information which is defined in Vinh et al. (2010).
"""
function expected_mutual_information(U::AbstractVector,
                                     V::AbstractVector)
    result = 0
    table = ContingencyTable(U, V)
    N = table.N
    a = table.a
    b = table.b
    for i = 1:table.R
        for j = 1:table.C
            for nij = max(1, a[i] + b[j] - N) : min(a[i], b[j])
                result += (nij / N) * log( N*nij / (a[i] * b[j])) *
                (f(a[i]) * f(b[j]) * f(N - a[i]) * f(N - b[j])) /
                (f(N) * f(nij) * f(a[i] - nij) * f(b[j] - nij) *
                f(N - a[i] - b[j] + nij))
            end
        end
    end
    result
end

f(x) = factorial(x)

"""
    adjusted_mutual_info_score(target, output, mode)
adjusted_mutual_info_score returns adjusted mutual information, which is a
variation ofmutual information that adjusts the effect of agreement due to
chance between clusterings. Vinh et al. (2010) defined four different
approaches, that they can be selected by 'mode' argument.
"""
function adjusted_mutual_info_score(target::AbstractVector,
                                    output::AbstractVector,
                                    mode::AbstractString = "max")
    if mode == "sqrt"
        denominator = sqrt(entropy(target) * entropy(output)) -
        expected_mutual_information(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (mutual_info_score(target, output) -
            expected_mutual_information(target, output)) /
                     denominator
        end
    elseif mode == "max"
        denominator = max(entropy(target) * entropy(output)) -
        expected_mutual_information(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (mutual_info_score(target, output) -
            expected_mutual_information(target, output)) /
                     denominator
        end
    elseif mode == "min"
        denominator = min(entropy(target) * entropy(output)) -
        expected_mutual_information(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (mutual_info_score(target, output) -
            expected_mutual_information(target, output)) /
                     denominator
        end
    elseif mode == "sum"
        denominator = (entropy(target) + entropy(output)) / 2 -
        expected_mutual_information(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (mutual_info_score(target, output) -
            expected_mutual_information(target, output)) /
                     denominator
        end
    else
        throw(DomainError())
    end
    result
end

"""
    adjusted_rand_score(target, output)
adjusted_rand_score returns adjusted rand score, which is a similarity measure
between two clusters and the return value ranges from -1 (no similarity) and
+1 (completely similar).
"""
function adjusted_rand_score(target::AbstractVector,
                             output::AbstractVector)
    table = ContingencyTable(target, output)
    N = table.N
    a = table.a
    b = table.b
    n = table.n
    index = sum(n .* (n .- 1) ./ 2)
    expected_index = sum(a .* (a .- 1) ./ 2) *
                     sum(b .* ( b .- 1) ./ 2) / ( N * (N - 1) / 2)
    max_index = 0.5 * (sum(a .* (a .- 1) ./ 2) + sum(b .* (b .- 1) ./ 2))
    if (max_index - expected_index) == 0
        return 0
    else
        return (index - expected_index) / (max_index - expected_index)
    end
end

"""
    homogeneity_score(target, output)
homogeneity_score returns the homogeneity measures as introduced in
Rosenberg and Hirschberg (2007). They define homogeneity: 'A clustering result
satisfies homogeneity if all of its clusters contain only data points which
are members of a single class'.
"""
function homogeneity_score(target::AbstractVector,
                           output::AbstractVector)
   if entropy(target, output) == 0 || entropy(target) == 0
        return 1.0
    else
        return 1.0 - (entropy_conditional(target, output) / entropy(target))
    end
end

"""
    completeness_score(target, output)
completeness_score returns the completeness measures as introduced in
Rosenberg and Hirschberg (2007). They define completeness: 'A clustering result
satisfies completeness if all the data points that are members of a given class
are elements of the same cluster'.
"""
function completeness_score(target::AbstractVector,
                            output::AbstractVector)
    return (homogeneity_score(output, target))
end

"""
    v_measure_score(target, output)
v_measure_score returns the harmonic mean of homogeneity and completeness
similar to f1_score.
"""
function v_measure_score(target::AbstractVector,
                         output::AbstractVector)
    2 * (homogeneity_score(target, output) *
    completeness_score(target, output)) /
    (homogeneity_score(target, output) + completeness_score(target, output))
end
