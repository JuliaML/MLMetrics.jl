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
"""
    immutable ContingencyTable(U, V)
ContingencyTable is the implementation of Contingency Table introduced
on Vinh et al. (2010). 'N' is the number of intances at both target and
output. 'R' is the number of clusters in target which becomesthe number
of rows. 'C' is the number of clusters in output whichbecomes the number
of columns. 'a', which is a vector, is themarginal distribution for target
and 'b' plays the same role foroutput. 'n', whihch is a 2D matrix, is the
joint distribution of taget and output.
"""
immutable ContingencyTable
    N::Int
    R::Int
    C::Int
    a::Array{Int}
    b::Array{Int}
    n::Array{Int,2}
    function ContingencyTable(U::AbstractVector,
                              V::AbstractVector)
    size(U) == size(V) ||
    throw(DimensionMismatch("Dimensions of the parameters don't match"))
    N = length(U)
    U_clusters = collect(Set(U))
    V_clusters = collect(Set(V))
    R = length(U_clusters)
    C = length(V_clusters)
    n = zeros(Int64, R, C)
    for i = 1:R
        for j = 1:C
            n[i, j] = NumberOfIntersection(U_clusters[i], U, V_clusters[j], V)
        end
    end
    a = reshape(sum(n, 2), R)
    b = reshape(sum(n, 1), C)
    new(N, R, C, a, b, n)
    end
end

"""
    NumberOf(item, list)
NumberOf returns the number of the item in the list
"""
function NumberOf(item::Any,
                  list::AbstractVector)
    length(find(list .== item))
end

"""
    NumberOfIntersection(item_1, list_1, item_2, list_2)
NumberOfIntersection returns the number of items in the intersection
of first item in the first liat and second item in the second list.
"""
function NumberOfIntersection(item_1::Any,
                              list_1::AbstractVector,
                              item_2::Any,
                              list_2::AbstractVector)
    logic_1 = item_1 .== list_1
    logic_2 = item_2 .== list_2
    length(find(logic_1 + logic_2 .== 2))
end

"""
    H(U)
H(U) returns the entropy of clustering 'U'.
"""
function H(U::AbstractVector)
    result = 0
    N = length(U)
    clusters = Set(U)
    for c in clusters
        a = NumberOf(c, U)
        result += (a / N) * log(a / N)
    end
    -result
end

"""
    H(U, V)
H(U, V) returns the joint entropy of clusterings 'U' and 'V'.
"""
function H(U::AbstractVector,
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
    H_conditional(U, V)
H_conditional(U, V) returns the conditional entropy of clusterings U given V.
"""
function H_conditional(U::AbstractVector,
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
    MI(target, output)
The Mutual Information is a measure of the similarity and the mutual
dependence between two labels or clusters of the same data.
"""
function MI(target::AbstractVector,
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

mutual_info_score(target, out) = MI(target, output)

"""
    normalized_MI(target, output, mode)
normalized_MI computes mutual information but it limits the range of the
return value from 0 (no similarity) to 1 (completely similar). There are
five different approaches introduced by Vinh et al. (2010), that they can
be selected by 'mode' argument.
"""
function normalized_MI(target::AbstractVector,
                       output::AbstractVector,
                       mode::String = "sqrt")
    result = 0
    if mode == "sqrt"
        denominator = sqrt(H(target) * H(output))
        if denominator == 0
            result = 0.0
        else
            result = MI(target, output) /
                     sqrt(H(target) * H(output))
        end
    elseif mode == "max"
        denominator = max(H(target), H(output))
        if denominator == 0
            result = 0.0
        else
            result = MI(target, output) /
                     max(H(target), H(output))
        end
    elseif mode == "min"
        denominator = min(H(target), H(output))
        if denominator == 0
            result = 0.0
        else
            result = MI(target, output) /
                     min(H(target), H(output))
        end
    elseif mode == "sum"
        denominator = H(target) + H(output)
        if denominator == 0
            result = 0.0
        else
            result = 2 * MI(target, output) /
                     (H(target) + H(output))
        end
    elseif mode == "joint"
        denominator = H(target, output)
        if denominator == 0
            result = 0.0
        else
            result = 2 * MI(target, output) /
                     H(target, output)
        end
    end
    result
end

normalized_mutual_info_score(target, output, mode) =
               normalized_MI(target, output, mode)

"""
    EMI(target, output)
EMI returns the expected value of mutual information which is defined
in Vinh et al. (2010).
"""
function EMI(U::AbstractVector,
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
    adjusted_MI(target, output, mode)
adjusted_MI returns adjusted mutual information, which is a variation of
mutual information that adjusts the effect of agreement due to chance between
clusterings. Vinh et al. (2010) defined four different approaches, that they
can be selected by 'mode' argument.
"""
function adjusted_MI(target::AbstractVector,
                     output::AbstractVector,
                     mode::String = "max")
    if mode == "sqrt"
        denominator = sqrt(H(target) * H(output)) - EMI(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (MI(target, output) -  EMI(target, output)) /
                     (sqrt(H(target) * H(output)) - EMI(target, output))
        end
    elseif mode == "max"
        denominator = max(H(target) * H(output)) - EMI(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (MI(target, output) -  EMI(target, output)) /
                     (max(H(target), H(output)) - EMI(target, output))
        end
    elseif mode == "min"
        denominator = min(H(target) * H(output)) - EMI(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (MI(target, output) -  EMI(target, output)) /
                     (min(H(target), H(output)) - EMI(target, output))
        end
    elseif mode == "sum"
        denominator = (H(target) + H(output)) / 2 - EMI(target, output)
        if denominator == 0
            result = 0.0
        else
            result = (MI(target, output) -  EMI(target, output)) /
                     ((H(target) + H(output)) / 2 - EMI(target, output))
        end
    end
    result
end

adjusted_mutual_info_score(target, output, mode) =
               adjusted_MI(target, output, mode)

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
    Index = sum(n .* (n .- 1) ./ 2)
    Expected_Index = sum(a .* (a .- 1) ./ 2) *
                     sum(b .* ( b .- 1) ./ 2) / ( N * (N - 1) / 2)
    Max_Index = 0.5 * (sum(a .* (a .- 1) ./ 2) + sum(b .* (b .- 1) ./ 2))
    if (Max_Index-Expected_Index) == 0
        return 0
    else
        return (Index - Expected_Index) / (Max_Index - Expected_Index)
    end
end

"""
    homogeneity(target, output)
homogeneity returns the homogeneity measures as introduced in
Rosenberg and Hirschberg (2007). They define homogeneity: 'A clustering result
satisfies homogeneity if all of its clusters contain only data points which
are members of a single class'.
"""
function homogeneity(target::AbstractVector,
                     output::AbstractVector)
   if H(target, output) == 0 || H(target) == 0
        return 1.0
    else
        return 1.0 - (H_conditional(target, output) / H(target))
    end
end

homogeneity_score(target, out) = homogeneity(target, output)

"""
    completeness(target, output)
completeness returns the completeness measures as introduced in
Rosenberg and Hirschberg (2007). They define completeness: 'A clustering result
satisfies completeness if all the data points that are members of a given class
are elements of the same cluster'.
"""
function completeness(target::AbstractVector,
                            output::AbstractVector)
    return (homogeneity_score(output, target))
end

completeness_score(target, out) = completeness(target, output)

"""
    v_measure_score(target, output)
v_measure_score returns the harmonic mean of homogeneity and completeness
similar to f1_score.
"""
function v_measure_score(target::AbstractVector,
                         output::AbstractVector)
    2 * (homogeneity(target, output) * completeness(target, output)) /
    (homogeneity(target, output) + completeness(target, output) )
end
