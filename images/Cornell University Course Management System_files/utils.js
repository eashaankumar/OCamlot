/**
 * Performs a not-in-place stable sort of arr,
 * using compareFunc which could otherwise be an argument to Array.prototype.sort
 * (i.e. it follows the same specification).
 *
 * @param {Array} arr
 * @param {Function} compareFunc
 * @returns {Array}
 */
function stableSort(arr, compareFunc) {
    var wrapped = arr.map(function (elem, idx) {
        return {
            elem: elem,
            idx: idx
        };
    });

    wrapped.sort(function (x, y) {
        var ret = compareFunc(x.elem, y.elem);

        // Never return 0; enforce stability by using the original index to compare in this case.
        if (ret === 0) {
            ret = (x.idx - y.idx);
        }

        return ret;
    });

    var sorted = wrapped.map(function (wrapper) {
        return wrapper.elem;
    });

    return sorted;
}