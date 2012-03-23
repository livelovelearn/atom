{View} = require 'space-pen'
CommandInterpreter = require 'command-interpreter'
Editor = require 'editor'

module.exports =
class CommandPanel extends View
  @content: ->
    @div class: 'command-panel', =>
      @div ':', class: 'prompt', outlet: 'prompt'
      @subview 'editor', new Editor

  commandInterpreter: null

  initialize: ({@rootView})->
    requireStylesheet 'command-panel.css'
    window.keymap.bindKeys '.command-panel .editor',
      escape: 'command-panel:toggle'
      enter: 'command-panel:execute'

    window.keymap.bindKeys '.editor',
      'meta-g': 'command-panel:repeat-relative-address'

    @rootView.on 'command-panel:toggle', => @toggle()
    @rootView.on 'command-panel:execute', => @execute()
    @rootView.on 'command-panel:repeat-relative-address', => @repeatRelativeAddress()
    @editor.addClass 'single-line'

    @commandInterpreter = new CommandInterpreter()

  toggle: ->
    if @parent().length then @hide() else @show()

  show: ->
    @rootView.append(this)
    @prompt.css 'font', @editor.css('font')
    @editor.focus()
    @editor.buffer.setText('')

  hide: ->
    @detach()
    @rootView.activeEditor().focus()

  execute: ->
    @commandInterpreter.eval(@rootView.activeEditor(), @editor.getText())
    @hide()

  repeatRelativeAddress: ->
    @commandInterpreter.repeatRelativeAddress(@rootView.activeEditor())
