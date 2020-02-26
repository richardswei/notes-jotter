import React from 'react'
import Note from "./Note";
import axios from "axios";
import $ from "jquery";

class NoteList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      notes: [],
      modalDefaultTitle: "",
      modalDefaultBody: "",
      modalIdToUpdate: null,
    };
    this.getNotes = this.getNotes.bind(this);
    this.handleNoteSubmit = this.handleNoteSubmit.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleNewNote = this.handleNewNote.bind(this);
    this.postNote = this.postNote.bind(this);
    this.putNote = this.putNote.bind(this);
    this.clearModalState = this.clearModalState.bind(this);
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

  // close(){
  //   this.setState({ showModal: false });
  // }

  postNote() {
    const csrfToken = document.querySelector('[name=csrf-token]').content
    axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken
    axios.post("/api/v1/notes", {
        note: {
          title: event.target.title.value,
          body: event.target.body.value,
        },
      })
      .then(response => {
        this.setState({notes: [response.data, ...this.state.notes] });
      })
      .then(() => {
        this.clearModalState()
        $("#noteModal").modal("hide");
      })
      .catch(error => console.log(error));
  }

  putNote(idNum) {
    const csrfToken = document.querySelector('[name=csrf-token]').content
    axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken
    axios.put(`/api/v1/notes/${idNum}`, {
        note: {
          title: event.target.title.value,
          body: event.target.body.value,
        },
      })
      .then(response => {
        this.getNotes();
      })
      .then(() => {
        $("#noteModal").modal("hide");
      })
      .catch(error => console.log(error));
  }

  clearModalState() {
    this.setState({
      modalDefaultTitle: "",
      modalDefaultBody: "",
      modalIdToUpdate: null,
    })
  }

  handleNoteSubmit(e, noteId) {
    e.preventDefault();
    if (noteId) {
      this.putNote(noteId)
    } else {
      this.postNote()
    }
  }

  handleDelete(id_to_del, e) {
    e.preventDefault();
    const csrfToken = document.querySelector('[name=csrf-token]').content
    axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken
    axios.delete(`/api/v1/notes/${id_to_del}`,)
      .then(response => {
        this.getNotes();
      })
      .catch(error => console.log(error));
  }

  handleUpdate(id, title, body) {
    $("#noteModal").find('form').trigger('reset');
    this.setState({ 
      modalIdToUpdate: id,
      modalDefaultTitle: title,
      modalDefaultBody: body,
    });
    $('#noteModal').modal('show')
  }
  handleNewNote() {
    $("#noteModal").find('form').trigger('reset');

    this.clearModalState();
    $('#noteModal').modal('show')
  }

  render() {
    return (
      <React.Fragment>
        <Modal
          handleNoteSubmit={this.handleNoteSubmit}
          noteId = {this.state.modalIdToUpdate}
          title = {this.state.modalDefaultTitle}
          body = {this.state.modalDefaultBody}
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
                    // data-toggle="modal"
                    onClick={this.handleNewNote}
                    className="btn-sm btn btn-outline-success"
                    // data-target="#noteModal"
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
                handleUpdate={this.handleUpdate}
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
  console.log(props.noteId)

  return (<div className="modal fade" id="noteModal" tabIndex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div className="modal-dialog modal-dialog-centered" role="document">
      <div className="modal-content">
        <div className="modal-header">
          <h5 className="modal-title" id="modalTitle">Note</h5>
          <button type="button" className="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <form onSubmit={(e)=>props.handleNoteSubmit(e, props.noteId)}>
          <div className="modal-body">
              <div className="form-group">
                <label htmlFor="titleInput">Title</label>
                <input type="text" 
                  defaultValue={props.title}
                  className="form-control" 
                  name="title" 
                  id="titleInput"/>
              </div>
              <div className="form-group">
                <label htmlFor="bodyInput">Body</label>
                <textarea 
                  defaultValue={props.body}
                  className="form-control" 
                  name="body" 
                  id="bodyInput" 
                  rows="2"></textarea>
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