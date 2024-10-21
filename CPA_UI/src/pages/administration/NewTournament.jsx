import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import toast from "react-hot-toast";

import axios from "../../axios.js"

import Input from "../../components/Input.jsx";
import { useInput } from "../../hooks/useInput.jsx";
import Button from "../../components/Button.jsx";
import { isText, isNotEmpty } from "../../util/Validation.js";

export default function NewTournament() {

  const [buttonDisabled, setButtonDisabled] = useState(false)
  const navigate = useNavigate()

  const {
    value: nameValue,
    handleInputChange: handleNameChange,
    handleInputBlur: handleNameBlur,
    hasError: nameHasError,

  } = useInput('', (value) => isNotEmpty(value));

  const {
    value: venueValue,
    handleInputChange: handleVenueChange,
    handleInputBlur: handleVenueBlur,
    hasError: venueHasError,

  } = useInput('', (value) =>  isNotEmpty(value));

  const {
    value: organiserValue,
    handleInputChange: handleOrganiserChange,
    handleInputBlur: handleOrganiserBlur,
    hasError: organiserHasError,

  } = useInput('', (value) => isText(value) && isNotEmpty(value));



  function handleSubmit(event) {
    event.preventDefault();
    const fd = new FormData(event.target);
    const data = Object.fromEntries(fd.entries());
    setButtonDisabled(true)

    axios.post("/administration/add_tournament", data).
      then(() => {
        setButtonDisabled(false);
        toast.success("Tournament added successfully!", { position: "top-right" });
        navigate(`/administration`);
      })
      .catch((error) => {
        console.error(error);
        setButtonDisabled(false);
        toast.error("An error occurred while adding Tournament data. Please try again later.", { position: "top-right" });
      })
  }




  return <>



    <form onSubmit={handleSubmit}>



      <h2>Welcome Administrator!</h2>
      <p>This is the page to add a new Tournament 🚀</p>

      <Input
        label="Tournament Name"
        id="name"
        type="text"
        name="name"
        onBlur={handleNameBlur}
        onChange={handleNameChange}
        value={nameValue}
        error={nameHasError && 'Please enter a valid tournament name!'}
        required
      />


      <div className="control-row">
        <Input
          label="Venue"
          id="venue"
          type="text"
          name="venue"
          onBlur={handleVenueBlur}
          onChange={handleVenueChange}
          value={venueValue}
          error={venueHasError && 'Please enter a valid Venue details!'}
          required
        />

        <Input
          label="Organising Country"
          id="organiser"
          type="text"
          name="organiser"
          onBlur={handleOrganiserBlur}
          onChange={handleOrganiserChange}
          value={organiserValue}
          error={organiserHasError && 'Please enter a valid Organising country details!'}
          required
        />
      </div>

      <div className="control-row">
        <div className="control">
          <label htmlFor="date_start">Tournament Interval - Start</label>
          <input type="date" id="date_start" name="date_start" required />
        </div>

        <div className="control">
          <label htmlFor="date_end">Tournament Interval -End</label>
          <input type="date" id="date_end" name="date_end" required />
        </div>
      </div>

      <p className="form-actions">

        <Link to={"/administration"}>
          <Button type="button" className="button button-flat">
            Cancel
          </Button>
        </Link>
        <Button
          type="submit"
          disabled={buttonDisabled}
        >
          Add Tournament
        </Button>
      </p>
    </form>
  </>
}