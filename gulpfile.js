var gulp = require('gulp'),
    autoprefixer = require('gulp-autoprefixer'),
    minifycss = require('gulp-minify-css'),
    uglify = require('gulp-uglify'),
    imagemin = require('gulp-imagemin'),
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    livereload = require('gulp-livereload'),
    notify = require('gulp-notify'),
    del = require('del'),
    sourcemaps = require('gulp-sourcemaps'),
    order = require('gulp-order'),
    fingerprint = require('gulp-fingerprint'),
    rev = require('gulp-rev'),
    streamqueue = require('streamqueue')
    watch = require('gulp-watch')
    batch = require('gulp-batch');

var paths = {
  css: ['src/css/**/*.css', 'src/css/default.css'],
  scripts: 'src/js/*.js',
  vendorScripts: 'src/js/vendor/**/*.js',
  allScripts: 'src/js/**/*.js',
  images: 'src/images/**/*',
  fonts: 'src/fonts/**/*',
  dest: 'assets/',
  maps: 'maps',
  build: 'build'
}

// handle the css minification and renaming
gulp.task('styles', function() {
    gulp.src(paths.css)
    .pipe(autoprefixer('last 2 version'))
    .pipe(concat('styles.css'))
    .pipe(sourcemaps.init())
      .pipe(rename({suffix: '.min'}))
      .pipe(minifycss())
    .pipe(sourcemaps.write(paths.maps))
    .pipe(gulp.dest(paths.dest + 'css'))
    .pipe(notify({ message: 'Styles task complete' }));
});

// handle the js minification and renaming
gulp.task('scripts', function() {
  del(paths.dest + 'js')
  return streamqueue({ objectMode: true },
    // make sure jQuery and jQueryUI are fist and exclude dataTables
    gulp.src(['src/js/vendor/jquery.js', 'src/js/vendor/jquery-ui.js', paths.vendorScripts])
        .pipe(concat('main.js'))
        .pipe(sourcemaps.init())
          .pipe(rename({suffix: '.min'}))
          .pipe(uglify(), {outSourceMap: true})
        .pipe(sourcemaps.write(paths.maps)),
    // now handle the other files that aren't getting concatenated
    gulp.src(paths.scripts)
        .pipe(sourcemaps.init())
          .pipe(rename({suffix: '.min'}))
          .pipe(uglify(), {outSourceMap: true})
        .pipe(sourcemaps.write(paths.maps))
  )
   //.pipe(rev.manifest({ base: paths.build }))
   .pipe(gulp.dest(paths.dest + 'js'))
   .pipe(notify({ message: 'Scripts task complete' }))
});

gulp.task('rev-test', function () {
    // by default, gulp would pick `assets/css` as the base, 
    // so we need to set it explicitly: 
    return gulp.src("/assets/js", {base: '/assets'})
        .pipe(gulp.dest('build/assets'))  // copy original assets to build dir 
        .pipe(rev())
        .pipe(gulp.dest('build/assets'))  // write rev'd assets to build dir 
        .pipe(rev.manifest())
        .pipe(gulp.dest('build/assets')); // write manifest to build dir 
});

// move the font files
gulp.task('fonts', function(){
    return gulp.src(paths.fonts)
    .pipe(gulp.dest(paths.dest + 'fonts'))
    .pipe(notify({ message: 'Fonts task complete' }));
});

// compress images
gulp.task('images', function() {
  return gulp.src(paths.images)
    .pipe(imagemin({ optimizationLevel: 3, progressive: true, interlaced: true }))
    .pipe(gulp.dest(paths.dest + 'images'))
    .pipe(notify({ message: 'Images task complete' }));
});

// Clean
gulp.task('clean', function(cb) {
    del([paths.dest + 'css', paths.dest + 'js', paths.dest + 'fonts', paths.dest + 'images'], cb)
});

// Default task
gulp.task('default', ['clean', 'styles', 'scripts', 'fonts', 'images'], function() {


});

// Watch
gulp.task('watch', function() {

  watch(paths.scripts, batch(function (events, done) {
      gulp.start('scripts', done);
  }));

  watch(paths.css, batch(function (events, done) {
      gulp.start('styles', done);
  }));

  watch(paths.images, batch(function (events, done) {
      gulp.start('images', done);
  }));

  watch(paths.fonts, batch(function (events, done) {
      gulp.start('fonts', done);
  }));

});