export function isText(value) {
    return value.includes("^[a-zA-Z0-9]") ;
}

export function isNotEmpty(value) {
    return value.trim() !== '';
}

export function hasMinLength(value, minLength) {
    return value.length >= minLength;
}