import React from 'react'
import PropTypes from 'prop-types'

class Note extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    const note = this.props.note
    return (
      <tr>
        <td>{note.title}</td>
        <td className="white-space-pre">{note.body}</td>
        <td className="text-right">
          <button 
            onClick = {(e)=>this.props.handleDelete(note.id, e)}
            className="btn-sm btn btn-outline-danger">&#65293; Delete</button>
          <button 
            onClick = {(e)=>this.props.handleUpdate(note.id, note.title, note.body)}
            className="btn-sm btn btn-outline-info">&#9998; Update</button>
        </td>
      </tr>
    )
  }
}

export default Note
