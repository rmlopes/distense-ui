import React, { Component } from 'react'
import { List, Segment } from 'semantic-ui-react'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'

import { watchEvents } from '../actions/events'

import Head from '../components/common/Head'
import Layout from '../components/Layout'

class Events extends Component {
  constructor(props) {
    super(props)
  }

  componentWillMount() {
    this.props.watchEvents()
  }

  shouldComponentUpdate(nextProps) {
    return this.props.events !== nextProps.events
  }

  render() {
    const { events } = this.props

    return (
      <Layout>
        <Head title="Create Task" />
        <Segment>
          <List>
            {events.length > 0
              ? events.map(event => <EventItem e={event} />)
              : 'Loading events...'}
          </List>
        </Segment>
      </Layout>
    )
  }
}

const EventItem = ({ e }) => (
  <List.Item>
    <List.Header>{e.contract}</List.Header>
    <List.Content />
    <List.Description>
      <Link to={`https://etherscan.io/tx/${e.txHash}`}>View tx</Link>
    </List.Description>
  </List.Item>
)

const mapStateToProps = state => ({
  events: state.events.events
})

const mapDispatchToProps = dispatch => ({
  watchEvents: () => dispatch(watchEvents())
})

export default connect(mapStateToProps, mapDispatchToProps)(Events)
