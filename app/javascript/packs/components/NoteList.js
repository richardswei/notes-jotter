import React from 'react'
import Note from "./Note";
import axios from "axios";


class NoteList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      notes: []
    };
    this.getNotes = this.getNotes.bind(this);
  }
  
  componentDidMount() {
    this.getNotes();
  }

  getNotes() {
    axios.get("/api/v1/notes")
      .then(response => this.setState({notes: response.data }))
      .catch(error => console.log(error))
  }
  render() {
    return (
      <React.Fragment>
        <div className="table-responsive">
          <table className="table">
            <thead>
              <tr>
                <th scope="col">Title</th>
                <th scope="col">Body</th>
                <th scope="col" className="note-actions text-right">
                  <button className="btn-sm btn btn-outline-success">
                    &#65291; New Note
                  </button>
                </th>
              </tr>
            </thead>
            <tbody>
            {this.state.notes.map(note => (
              <Note key={note.id} note={note} />
            ))}
            </tbody>
          </table>
        </div>
      </React.Fragment>
    )
  }
}
export default NoteList