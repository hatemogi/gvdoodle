(function() {
  var app;

  app = angular.module("gvdoodle", ["ui.bootstrap"]);

  app.controller("EditorCtrl", [
    '$scope', '$http', '$sce', '$modal', function($scope, $http, $sce, $modal) {
      var editor, loadSVG, self;
      self = this;
      self.isLoading = false;
      self.showPreview = false;
      self.changed = false;
      window.editor = editor = ace.edit("editor");
      editor.setTheme("ace/theme/tomorrow");
      editor.getSession().setMode("ace/mode/dot");
      editor.focus();
      editor.on("change", function() {
        var before;
        if (!self.loadedValue) {
          return;
        }
        before = self.changed;
        self.changed = editor.getValue() !== self.loadedValue;
        if (before !== self.changed) {
          return $scope.$apply();
        }
      });
      this.engine = 'dot';
      this.preview = 'preview.svg';
      this.engines = ['dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo'];
      loadSVG = function(data, status) {
        $scope.svg = $sce.trustAsHtml(data);
        self.showPreview = true;
        self.isLoading = false;
        return console.log(['success', data]);
      };
      this.loadSaved = function(gvid) {
        return $http.get("/" + gvid + ".svg").success(loadSVG);
      };
      this.run = function(e) {
        self.isLoading = true;
        return $http.post("/preview", {
          text: editor.getValue(),
          engine: self.engine
        }).success(loadSVG).error(function(res) {
          return console.log(['error', res]);
        });
      };
      this.publishModal = function(e) {
        return $modal.open({
          templateUrl: "template/publish"
        });
      };
      this.publish = function(e) {
        self.isLoading = true;
        return $http.post("/publish", {
          text: editor.getValue(),
          engine: self.engine
        }).success(function(data, status) {
          return window.location.href = "/" + data.gvid;
        }).error(function(res) {
          return console.log(['publish error', res]);
        });
      };
      this.img_load = function(e) {
        return console.dir(e);
      };
      this.load = function(id) {
        $http.get("/" + id + ".gv").success(function(data, status) {
          editor.setValue(data);
          editor.clearSelection();
          return self.loadedValue = data;
        });
        $http.get("/" + id + ".meta").success(function(data, status) {
          if (data && data.engine) {
            self.engine = data.engine;
          }
          return status;
        });
        self.svg_url = "/" + id + ".svg";
        self.showPreview = false;
        return id;
      };
      return this;
    }
  ]);

  app.directive('resizable', function() {
    return {
      link: function(scope, e, attrs) {
        return e.bind('load', function(ev) {
          return console.dir([e[0].width, e[0].height]);
        });
      }
    };
  });

}).call(this);

//# sourceMappingURL=app.js.map
