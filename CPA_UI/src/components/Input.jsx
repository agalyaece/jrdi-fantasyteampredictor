import PropTypes from "prop-types"

function Input({ label, id, error, ...props }) {
    return (
        <div className="control no-margin">
            <label htmlFor={id}>{label}</label>
            <input id={id} required {...props} />
            <div className="control-error">{error && <p>{error}</p>}</div>
        </div>
    );
}

Input.propTypes = {
    label: PropTypes.string,
    id: PropTypes.any,
    error: PropTypes.any,
};

export default Input;