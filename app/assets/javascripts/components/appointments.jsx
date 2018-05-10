class Appointments extends React.Component {
  render() {
    let appointmentList = <ul>{this.props.data.map((a) =>
        <Appointment key={a.id} data={a}></Appointment>
      )}</ul>
    return <div>
      <h1>Appointments</h1>
      {this.props.data.length ? appointmentList : <p>No results</p>}
    </div>
  }
}
