import React from 'react'
import Note from "./Note";
import axios from "axios";
import $ from "jquery";

class NoteList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      notes: [],
    };
    this.getNotes = this.getNotes.bind(this);
    this.handleNoteSubmit = this.handleNoteSubmit.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
  }
  
  componentDidMount() {
    this.getNotes();
  }

  getNotes() {
    axios.get("/api/v1/notes")
      .then(response => 
        this.setState({ notes: response.data })
      )
      .catch(error => console.log(error))
  }

  close(){
    this.setState({ showModal: false });
  }

  handleNoteSubmit(e) {
    e.preventDefault();
    const csrfToken = document.querySelector('[name=csrf-token]').content
    axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken
    console.log(csrfToken)
    axios.post("/api/v1/notes", {
        note: {
          title: event.target.title.value,
          body: event.target.body.value,
        },
      })
      .then(response => {
        console.log(this.state)
        this.setState({notes: [response.data, ...this.state.notes] });
      })
      .then(() => {
        $("#noteModal").modal("hide");
      })
      .catch(error => console.log(error));

  }

  handleDelete(id_to_del, e) {
    e.preventDefault();
    const csrfToken = document.querySelector('[name=csrf-token]').content
    axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken
    console.log(csrfToken)
    axios.delete(`/api/v1/notes/${id_to_del}`,)
      .then(response => {
        this.getNotes();
      })
      .catch(error => console.log(error));

  }

  render() {
    return (
      <React.Fragment>
        <Modal
          handleNoteSubmit={this.handleNoteSubmit}
        />
        <div className="table-responsive table-hover">
          <table className="table">
            <thead>
              <tr>
                <th scope="col">Title</th>
                <th scope="col">Body</th>
                <th scope="col" className="note-actions text-right">
                  <button 
                    type="button" 
                    data-toggle="modal"
                    className="btn-sm btn btn-outline-success"
                    data-target="#noteModal"
                    >&#65291; New Note
                  </button>
                </th>
              </tr>
            </thead>
            <tbody>
            {this.state.notes.map(note => (
              <Note 
                key={note.id} 
                note={note}
                id={note.id}
                handleDelete={this.handleDelete}
              />
            ))}
            </tbody>
          </table>
        </div>
      </React.Fragment>
    )
  }
}
export default NoteList

function Modal(props) {
  return (<div className="modal fade" id="noteModal" tabIndex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div className="modal-dialog modal-dialog-centered" role="document">
      <div className="modal-content">
        <div className="modal-header">
          <h5 className="modal-title" id="modalTitle">Note</h5>
          <button type="button" className="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form onSubmit={props.handleNoteSubmit}>
          <div className="modal-body">
              <div className="form-group">
                <label htmlFor="titleInput">Title</label>
                <input type="text" className="form-control" name="title" id="titleInput"/>
              </div>
              <div className="form-group">
                <label htmlFor="bodyInput">Body</label>
                <textarea className="form-control" name="body" id="bodyInput" rows="2"></textarea>
              </div>
          </div>
          <div className="modal-footer">
            <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="submit" className="btn btn-primary">Save</button>
          </div>
        </form>
      </div>
    </div>
  </div>)
}