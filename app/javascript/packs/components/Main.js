import React from 'react'
import ReactDOM from 'react-dom'

class Main extends React.Component {
  render() {
    return <div className="main-panel-dash">Main</div>
  }
}

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('main')
  app && ReactDOM.render(<Main />, app)
})