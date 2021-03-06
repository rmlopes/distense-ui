import React, { Component } from 'react'
import { connect } from 'react-redux'
import { Button, Card, Grid, Header, Segment } from 'semantic-ui-react'

import { voteOnParameter } from '../actions/parameters'
import { getParameters } from '../reducers/parameters'

import Head from '../components/common/Head'
import { constructClientParameterDetails } from '../helpers/parameters/constructClientParameterDetails'

class Parameters extends Component {
  constructor(props) {
    super(props)
    this.state = {
      parameters: this.props.parameters || [],
      parameterValue: ''
    }
  }

  componentDidMount() {
    this.paramTimeout = setTimeout(() => {
      this.setState({
        loading: false,
        parameters: this.props.parameters
      })
    }, 2000)
  }

  componentWillUnmount() {
    clearTimeout(this.paramTimeout)
  }

  handleInputChange(event) {
    const target = event.target
    const name = target.name
    const value = target.value

    if (value.length < 3)
      this.setState({
        [name]: value
      })
  }

  onClick = async (title, vote, e) => {
    e.preventDefault()

    this.props.voteOnParameter({ title, vote })
    this.setState({
      redirect: true
    })
  }

  render() {
    const { parameters } = this.props
    const { parameterValue } = this.state

    return (
      <div>
        <Head title="Votable Parameters" />
        <Header as="h1">Parameters</Header>
        <Header as="h3">Govern if you dare (and own DID)</Header>
        <Grid.Row>
          <Card.Group>
            {parameters.length > 0 ? (
              parameters.map((parameter, i) => (
                <Parameter
                  key={i}
                  param={parameter}
                  onChange={this.handleInputChange}
                  onClick={this.onClick}
                  parameterValue={parameterValue}
                />
              ))
            ) : (
              <Card className="parameter-card-width" raised>
                <Segment>Loading Distense parameters...</Segment>
              </Card>
            )}
          </Card.Group>
        </Grid.Row>
        {/*language=CSS*/}
        <style global jsx>{`
          .parameter-card-width {
            width: 366px !important;
          }
        `}</style>
      </div>
    )
  }
}

const Parameter = ({ param, onClick }) => {
  const p = constructClientParameterDetails(param)

  return (
    <Card className="parameter-card-width" raised>
      <Card.Content>
        <Card.Header>{p.title}</Card.Header>
        <Card.Meta>{p.placeholder}</Card.Meta>
        <Card.Content>Current Value: {p.value}</Card.Content>
        <Card.Content extra>
          <Button
            color="black"
            id="upvote"
            basic
            onClick={e => onClick(p.title, 'upvote', e)}
          >
            DownVote
          </Button>
          <Button
            color="black"
            id="downvote"
            basic
            onClick={e => onClick(p.title, 'downvote', e)}
          >
            UpVote
          </Button>
        </Card.Content>
      </Card.Content>
    </Card>
  )
}

const mapStateToProps = state => ({
  parameters: getParameters(state)
})

const mapDispatchToProps = dispatch => ({
  voteOnParameter: vote => dispatch(voteOnParameter(vote))
})

export default connect(mapStateToProps, mapDispatchToProps)(Parameters)
