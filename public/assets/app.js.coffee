app = angular.module("gvdoodle", [])
app.controller "EditorCtrl", ['$scope', '$http', '$sce', ($scope, $http, $sce) ->
  window.editor = editor = ace.edit("editor")
  # editor.setTheme("ace/theme/clouds")
  editor.setTheme("ace/theme/tomorrow")
  # editor.setTheme("ace/theme/crimson_editor")
  editor.getSession().setMode("ace/mode/dot")
  # editor.getSession().setUseWrapMode true
  editor.focus()

  this.engine = 'dot'
  this.preview = 'preview.svgz'
  this.engines = ['dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo']

  self = this
  self.isLoading = false
  loadSVG = (data, status) ->
    $scope.svg = $sce.trustAsHtml(data)
    self.show_preview = true
    self.isLoading = false
    console.log ['success', data]
    # $('#output svg').attr("width", "100%").attr("height", "100%")

  this.loadSaved = (gvid) ->
    $http.get("/#{gvid}.svg").success(loadSVG)
  this.run = (e) ->
    # $http.defaults.headers.post["Content-Type"] = "text/plain"
    self.isLoading = true
    $http.post("/preview", {
      text: editor.getValue()
      engine: self.engine
    }).success(loadSVG).error (res) ->
      console.log ['error', res]
  this.img_load = (e) ->
    console.dir e
  this.load = (id) ->
    $http.get("/#{id}.gv").success((data, status) ->
      editor.setValue data
      editor.clearSelection()
    )
    $http.get("/#{id}.meta").success((data, status) ->
      if data && data.engine
        self.engine = data.engine
      status
    )
    self.svg_url = "/#{id}.svgz"
    self.show_preview = false
    id
  this
]

app.directive 'resizable', ->
  {
    link: (scope, e, attrs) ->
      e.bind 'load', (ev) ->
        console.dir [e[0].width, e[0].height]
        # e[0].width = 500
  }
