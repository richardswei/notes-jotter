import React from 'react'
import ReactDOM from 'react-dom'
import NoteList from "./NoteList";

class Dashboard extends React.Component {
  
  render() {
    return (
      <div className="main-panel-dash">
        <h2>Notes Dashboard</h2>
        <NoteList/>
      </div>
    )
  }
}

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('main')
  app && ReactDOM.render(<Dashboard />, app)
})