CrystalAtomView = require './crystal-atom-view'
{CompositeDisposable} = require 'atom'
path = require 'path'

module.exports = CrystalAtom =
  crystalAtomView: null
  panel: null
  subscriptions: null

  activate: (state) ->
    @crystalAtomView = new CrystalAtomView(state.crystalAtomViewState)
    @panel = atom.workspace.addRightPanel(item: @crystalAtomView.getElement(), visible: false)

    # Add btn event
    @crystalAtomView.getCompileButton().addEventListener('click', (event) => @_compileProject())
    @crystalAtomView.getOpenCrystalButton().addEventListener('click', (event) => @_openCrystalApp())

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable()

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'crystal-atom:toggle': => @toggle()
    @_iscompiling = no

  deactivate: ->
    @panel.destroy()
    @subscriptions.dispose()
    @crystalAtomView.destroy()

  serialize: ->
    crystalAtomViewState: @crystalAtomView.serialize()

  toggle: ->
    if @panel.isVisible()
      @panel.hide()
    else
      @panel.show()

  # @access protected
  _compileProject: ->
    return if @_iscompiling
    console.log('compiling project')
    @_iscompiling = yes
    @crystalAtomView.setCompiling(yes)
    spawn = require('child_process').spawn
    coffee = spawn('coffee',
      [ '-o'
      , path.join(@crystalAtomView.getCrystalRootPath(), 'lib/examples/')
      , '-cm'
      , path.join(@crystalAtomView.getProjectRootPath(), './')
      ])
    coffee.stdout.on('data',
      (data) =>
        console.log("stdout: #{data}")
        @crystalAtomView.output()
        @crystalAtomView.output(data, 'info'))
    coffee.stderr.on('data',
      (data) =>
        console.log("stderr: #{data}")
        @crystalAtomView.output()
        @crystalAtomView.output(data, 'error'))
    coffee.on('close',
      (code) =>
        console.log("coffee exited with code: #{code}")
        if code is 0 then @crystalAtomView.output()
        @crystalAtomView.setCompiling(no)
        @_iscompiling = no)
    return

  _openCrystalApp: ->
    spawn = require('child_process').spawn
    crystal = spawn('npm',
      [ 'start'
      , '--prefix'
      , path.join(@crystalAtomView.getCrystalRootPath(), './')
      ])
    crystal.stdout.on('data',
      (data) =>
        console.log("stdout: #{data}")
        @crystalAtomView.output()
        @crystalAtomView.output(data, 'info'))
    crystal.stderr.on('data',
      (data) =>
        console.log("stderr: #{data}")
        @crystalAtomView.output()
        @crystalAtomView.output(data, 'error'))
    crystal.on('close',
      (code) =>
        console.log("Crystal exited with code: #{code}")
        if code is 0 then @crystalAtomView.output())
    return
