import React from 'react'
import PropTypes from 'prop-types'

class Note extends React.Component {
  constructor(props) {
    super(props)
  }
  render() {
    const { note } = this.props
    return (
      <tr>
        <td>{note.title}</td>
        <td>{note.body}</td>
        <td className="text-right">
          <button className="btn-sm btn btn-outline-danger">&#65293; Delete</button>
          <button className="btn-sm btn btn-outline-info">&#9998; Update</button>
        </td>
      </tr>
    )
  }
}

export default Note

Note.propTypes = {
  note: PropTypes.object.isRequired,
}
