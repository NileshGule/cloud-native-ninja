import React, { useState,useEffect  } from "react";
// import axios from "axios";

function GenerateTechTalk(): JSX.Element {
  const [selectedValue, setSelectedValue] = useState<string>("");
  const [responseCode, setResponseCode] = useState(0);
//   const [data, setData] = useState([]);
const [message, setMessage] = useState("");

  const thanksMessage = "Thank You";

  const handleInputChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
    setSelectedValue(event.target.value);
  };

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    console.log(`Selected value: ${selectedValue}`);

    const response = await fetch(`http://20.198.131.129:8080/generate/${selectedValue}`, {mode:'no-cors'});
    // const response = await fetch(`http://20.198.131.129:8080/generate/500`, {mode:'no-cors'});

    let responseStatus = await response.status;

    setResponseCode(response.status);

    console.log(`Response code: ${response.status}`);

    // if (responseCode === 200) {
    if (responseCode === 0) {
        setMessage(`Success! Generated ${selectedValue} Tech Talks!`);
    } else {
        setMessage("Failure! Something went wrong.");
    }
  };

  
  

  return (
    <div>
        <form onSubmit={handleSubmit}>
        <label>
          Select the number of Tech Talks to generate:
      <select value={selectedValue} onChange={handleInputChange}>
        <option value="50">50</option>
        <option value="500">500</option>
        <option value="5000">5000</option>
        <option value="10000">10000</option>
        <option value="50000">50000</option>
      </select>
      </label>
        <button type="submit">Submit</button>
      </form>

      {
        <div>
          Response code: {responseCode}
          <br />
          {message}
          <br/>
          {thanksMessage}
        </div>
      }
    </div>
  );
}

export default GenerateTechTalk;
