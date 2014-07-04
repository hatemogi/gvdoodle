app = angular.module("gvdoodle", ["ui.bootstrap"])
app.controller "EditorCtrl", ['$scope', '$http', '$sce', '$modal',
  ($scope, $http, $sce, $modal) ->
    self = this
    reset = ->
      self.isLoading = false
      self.showPreview = false
      self.gvChanged = false
    self.changed = ->
      this.gvChanged || this.ranEngine != this.engine

    window.editor = editor = ace.edit("editor")
    editor.setTheme("ace/theme/tomorrow")
    editor.getSession().setMode("ace/mode/dot")
    editor.focus()
    editor.on "change", () ->
      return unless !!self.loadedValue
      before = self.gvChanged
      self.gvChanged = editor.getValue() != self.loadedValue
      $scope.$apply() unless before == self.gvChanged
    this.engine = 'dot'
    this.preview = 'preview.svg'
    this.engines = ['dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo']

    loadSVG = (data, status) ->
      $scope.svg = $sce.trustAsHtml(data)
      self.showPreview = true
      self.isLoading = false
      console.log ['success', data]
      # $('#output svg').attr("width", "100%").attr("height", "100%")

    this.loadSaved = (gvid) ->
      $http.get("/#{gvid}.svg").success(loadSVG)
    this.run = (e) ->
      self.isLoading = true
      self.ranEngine = self.engine
      $http.post("/preview", {
        text: editor.getValue()
        engine: self.engine
      }).success(loadSVG).error (res) ->
        console.log ['error', res]
    this.publishModal = (e) ->
      if self.changed()
        modal = $modal.open {
          scope: $scope
          templateUrl: "template/publish"
        }
        modal.result.then (e) ->
          self.publish()
    this.publish = (e) ->
      console.log "publish called"
      self.isLoading = true
      $http.post("/publish", {
        text: editor.getValue()
        engine: self.engine
      }).success((data, status) ->
        window.location.href = "/#{data.gvid}"
      ).error (res) ->
        console.log ['publish error', res]
    this.img_load = (e) ->
      console.dir e
    this.load = (id) ->
      self.id = id
      $http.get("/#{id}.gv").success((data, status) ->
        editor.setValue data
        editor.clearSelection()
        self.loadedValue = data
      )
      $http.get("/#{id}.meta").success((data, status) ->
        if data && data.engine
          self.engine = self.ranEngine = data.engine
        status
      )
      self.svg_url = "/#{id}.svg"
      self.showPreview = false
      id
    this
]

app.directive 'resizable', ->
  {
    link: (scope, e, attrs) ->
      e.bind 'load', (ev) ->
        # console.dir [e[0].width, e[0].height]
        # e[0].width = 500
  }
