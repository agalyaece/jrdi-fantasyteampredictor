import PropTypes from "prop-types"

function Button({ children, ...props }) {
    return (
        <button
            {...props}
        >
            {children}
        </button>
    );
}

Button.propTypes = {
    children: PropTypes.any,
};

export default Button;