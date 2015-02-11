var gulp = require('gulp');
var coffee = require('gulp-coffee');
var stylus = require('gulp-stylus');
var uglify = require('gulp-uglify');
var sourcemaps = require('gulp-sourcemaps');
var del = require('del');
var minifycss = require('gulp-minify-css');
var gutil = require('gulp-util');
var plumber = require('gulp-plumber');
var autoprefixer = require('autoprefixer-stylus');

var paths = {
	scriptsStatic: 'src/static_files/scripts/**/*.coffee',
	scriptsLib: 'src/lib_files/**/scripts/**/*.coffee',

	stylesStatic: 'src/static_files/styles/**/*.styl',
	stylesLib: 'src/lib_files/**/styles/**/*.styl',

	imagesStatic: 'src/static_files/img/**/*',
	imagesLib: 'src/lib_files/**/img/**/*',

	copyStatic: [
		'src/static_files/**/*',
		'!src/static_files/{scripts,scripts/**}',
		'!src/static_files/{styles,styles/**}',
		'!src/static_files/{img,img/**}'
	],

	copyLib: [
		'src/lib_files/**/*',
		'!src/lib_files/**/{scripts,scripts/**}',
		'!src/lib_files/**/{styles,styles/**}',
		'!src/lib_files/**/{img,img/**}'
	]
};

// Emancipate yourself from build-folder slavery
// None but ourselves can free our project
//    - Bob Marley
gulp.task('clean', function(cb) {
	del(['build'], cb);
});

// Transpile coffee, minify and provide sourcemaps
gulp.task('scripts-static', function() {
	return gulp.src(paths.scriptsStatic)
		.pipe(plumber())
		.pipe(sourcemaps.init())
			.pipe(coffee())
			.pipe(uglify())
		.pipe(sourcemaps.write())
		.pipe(gulp.dest('build/static/js'));
});

gulp.task('scripts-lib', function() {
	return gulp.src(paths.scriptsLib)
		.pipe(plumber())
		.pipe(sourcemaps.init())
			.pipe(coffee())
			.pipe(uglify())
		.pipe(sourcemaps.write())
		.pipe(gulp.dest('build/lib/'));
});

// Process styling and minify
gulp.task('styles-static', function(target){
	return gulp.src(paths.stylesStatic)
		.pipe(plumber())
		.pipe(stylus({
			use: [autoprefixer({ browser: 'last 3 versions' })]
		}))
		.pipe(minifycss())
		.pipe(gulp.dest('build/static/css'));
});

gulp.task('styles-lib', function(target){
	return gulp.src(paths.stylesLib)
		.pipe(plumber())
		.pipe(stylus({
			use: [autoprefixer({ browser: 'last 3 versions' })]
		}))
		.pipe(minifycss())
		.pipe(gulp.dest('build/lib/'));
});

// Copy all static images
gulp.task('images-static', function() {
	return gulp.src(paths.imagesStatic)
		.pipe(plumber())
		.pipe(gulp.dest('build/static/img'));
});

gulp.task('images-lib', function() {
	return gulp.src(paths.imagesLib)
		.pipe(plumber())
		.pipe(gulp.dest('build/lib/**/img'));
});

// Copy anything that's not transpiled
gulp.task('copy-static', function() {
	return gulp.src(paths.copyStatic)
		.pipe(gulp.dest('./build/static'));
});

gulp.task('copy-lib', function() {
	return gulp.src(paths.copyLib)
		.pipe(gulp.dest('./build/lib'));
});

// Rerun the task when a file changes
gulp.task('watch-static', function() {
	gulp.watch(paths.scriptsStatic, ['scripts-static']);
	gulp.watch(paths.stylesStatic, ['styles-static']);
	gulp.watch(paths.imagesStatic, ['images-static']);
});

gulp.task('watch-lib', function() {
	gulp.watch(paths.scriptsLib, ['scripts-lib']);
	gulp.watch(paths.stylesLib, ['styles-lib']);
	gulp.watch(paths.imagesLib, ['images-lib']);
});

// Chains
gulp.task('deploy-static', function(){
	return gulp.start('scripts-static', 'styles-static', 'images-static', 'copy-static');
});

gulp.task('deploy-lib', function(){
	return gulp.start('scripts-lib', 'styles-lib', 'images-lib', 'copy-lib');
});

gulp.task('deploy', function(){
	return gulp.start('deploy-static', 'deploy-lib');
});

gulp.task('scripts', function(){
	return gulp.start('scripts-static', 'scripts-lib');
});

gulp.task('images', function(){
	return gulp.start('images-static', 'images-lib');
});

gulp.task('styles', function(){
	return gulp.start('styles-static', 'styles-lib');
});

gulp.task('copy', function(){
	return gulp.start('copy-static', 'copy-lib');
});

gulp.task('watch', function(){
	return gulp.start('watch-static', 'watch-lib');
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', function(){
	gutil.log('No default task, use', gutil.colors.green('gulp <task>-<target>'), 'instead');
	gutil.log('Target is either', gutil.colors.green('static'), 'or', gutil.colors.green('lib'));
	gutil.log('Running a task with no target will run it on both', gutil.colors.green('static'), 'and', gutil.colors.green('lib'));
	gutil.log(gutil.colors.green('clean'), 'to clean the project of previous builds');
	gutil.log(gutil.colors.green('scripts-<target>'), 'to process scripts');
	gutil.log(gutil.colors.green('styles-<target>'), 'to process styles');
	gutil.log(gutil.colors.green('images-<target>'), 'to process images');
	gutil.log(gutil.colors.green('watch-<target>'), 'to watch for changes');
	gutil.log(gutil.colors.green('deploy-<target>'), 'to prep files for deployment');
});