import PropTypes from 'prop-types';

function Modal({ children, onClose }) {


    return <>
        <div className="backdrop" onClick={onClose}> </div>
        <dialog open className="modal" >
            {children}
        </dialog>
    </>
}

Modal.propTypes = {
    onClose: PropTypes.func.isRequired,
    children: PropTypes.node,

};

export default Modal;