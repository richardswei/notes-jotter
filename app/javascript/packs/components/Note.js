import React from 'react'
import {timeSince} from '../helpers/Time'

class Note extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    const note = this.props.note
    const updated = note.updated_at != note.created_at;

    return (
      <tr data-toggle="tooltip" data-placement="auto" title={`Updated on: ${Date.parse(note.updated_at).toString()}`}>
        <td>
          <div>{note.title}</div>
          <div class="text-muted font-italic no-wrap">{updated ? `Updated ${timeSince(note.updated_at)} ago` :`Created ${timeSince(note.created_at)} ago`}</div>
        </td>
        <td className="white-space-pre">{note.body}</td>
        <td className="text-right">
          <button 
            onClick = {(e)=>this.props.handleDelete(note.id, e)}
            className="btn-sm btn btn-outline-danger">&#65293; Delete</button>
          <br/>
          <button 
            onClick = {(e)=>this.props.handleUpdate(note.id, note.title, note.body)}
            className="mt-1 btn-sm btn btn-outline-info">&#9998; Update</button>
        </td>
      </tr>
    )
  }
}

export default Note
