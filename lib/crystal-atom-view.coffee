class CrystalAtomView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    # Create a panel
    @panel   = document.createElement('div')
    @_init(serializedState)


  # Returns an object that can be retrieved when package is activated
  serialize: ->
    obj =
      'crystal-root': @getCrystalRootPath()

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  getProjectRootPath: ->
    document.getElementById("project-root").getModel().getText()

  getCrystalRootPath: ->
    document.getElementById("crystal-root").getModel().getText()

  getCompileButton: ->
    document.getElementById('compile')

  getOpenCrystalButton: ->
    document.getElementById('crystal-open')

  setCompiling: (iscompiling) ->
    if iscompiling
      document.getElementById('compile').innerHTML = '<span class="loading loading-spinner-small inline-block"></span>'
    else
      document.getElementById('compile').innerHTML = '<span class="icon icon-beer"></span>Compile'
    return

  output: (text, type) ->
    if text?
      msg = document.createElement('div')
      msg.className = 'text-' + type
      msg.id = 'compile-msg'
      msg.innerHTML = text
      @panel.appendChild(msg)
    else
      document.getElementById('compile-msg')?.remove()
    return

  _init: (serializedState) ->
    @element.classList.add('crystal-atom')
    # Create message element
    message = document.createElement('div')
    message.classList.add('message')
    message.innerHTML =
      '''
      <p>
        &nbsp;&nbsp;<span class="icon icon-mark-github"></span>
        &nbsp;&nbsp;The CrystalAtom package created by Nezha 2016
      </p>
      '''
    @element.appendChild(message)

    # Create panel element
    projectpath = atom.project.getPaths()?[0] ? '~/Path-to-Your-Project-Root'
    crystalpath = serializedState?['crystal-root'] ? '~/Path-to-Crystal-Root'
    @panel.className = 'crystal-atom-panel'
    @panel.innerHTML =
      """
      <div class="block">
      <h3><label><span class="icon icon-file-directory"></span> Your Project Root Directory </label></h3>
        <atom-text-editor mini id="project-root">#{projectpath}</atom-text-editor>
      </div>
      <div class="block">
      <h3><label><span class="icon icon-file-directory"></span> Crystal Root Directory </label></h3>
        <atom-text-editor mini id="crystal-root">#{crystalpath}</atom-text-editor>
      </div>
      <div class="block">
          <button id="compile" class="btn btn-lg"><span class="icon icon-beer"></span>Compile</button>
          <button id="crystal-open" class="btn btn-lg"><span class="icon icon-ruby"></span>Open Crystal</button>
      </div>
      """
    @element.appendChild(@panel)



module.exports = CrystalAtomView
