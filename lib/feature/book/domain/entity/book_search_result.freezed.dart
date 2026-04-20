// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookSearchResult {

 String get id; String get title; String? get author; String? get publisher; String? get pubDate; String? get isbn13; String? get cover; String? get description; String? get categoryName;
/// Create a copy of BookSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookSearchResultCopyWith<BookSearchResult> get copyWith => _$BookSearchResultCopyWithImpl<BookSearchResult>(this as BookSearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,publisher,pubDate,isbn13,cover,description,categoryName);

@override
String toString() {
  return 'BookSearchResult(id: $id, title: $title, author: $author, publisher: $publisher, pubDate: $pubDate, isbn13: $isbn13, cover: $cover, description: $description, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $BookSearchResultCopyWith<$Res>  {
  factory $BookSearchResultCopyWith(BookSearchResult value, $Res Function(BookSearchResult) _then) = _$BookSearchResultCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? author, String? publisher, String? pubDate, String? isbn13, String? cover, String? description, String? categoryName
});




}
/// @nodoc
class _$BookSearchResultCopyWithImpl<$Res>
    implements $BookSearchResultCopyWith<$Res> {
  _$BookSearchResultCopyWithImpl(this._self, this._then);

  final BookSearchResult _self;
  final $Res Function(BookSearchResult) _then;

/// Create a copy of BookSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = freezed,Object? publisher = freezed,Object? pubDate = freezed,Object? isbn13 = freezed,Object? cover = freezed,Object? description = freezed,Object? categoryName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookSearchResult].
extension BookSearchResultPatterns on BookSearchResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookSearchResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _BookSearchResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _BookSearchResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? author,  String? publisher,  String? pubDate,  String? isbn13,  String? cover,  String? description,  String? categoryName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookSearchResult() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.publisher,_that.pubDate,_that.isbn13,_that.cover,_that.description,_that.categoryName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? author,  String? publisher,  String? pubDate,  String? isbn13,  String? cover,  String? description,  String? categoryName)  $default,) {final _that = this;
switch (_that) {
case _BookSearchResult():
return $default(_that.id,_that.title,_that.author,_that.publisher,_that.pubDate,_that.isbn13,_that.cover,_that.description,_that.categoryName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? author,  String? publisher,  String? pubDate,  String? isbn13,  String? cover,  String? description,  String? categoryName)?  $default,) {final _that = this;
switch (_that) {
case _BookSearchResult() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.publisher,_that.pubDate,_that.isbn13,_that.cover,_that.description,_that.categoryName);case _:
  return null;

}
}

}

/// @nodoc


class _BookSearchResult implements BookSearchResult {
  const _BookSearchResult({required this.id, required this.title, this.author, this.publisher, this.pubDate, this.isbn13, this.cover, this.description, this.categoryName});
  

@override final  String id;
@override final  String title;
@override final  String? author;
@override final  String? publisher;
@override final  String? pubDate;
@override final  String? isbn13;
@override final  String? cover;
@override final  String? description;
@override final  String? categoryName;

/// Create a copy of BookSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookSearchResultCopyWith<_BookSearchResult> get copyWith => __$BookSearchResultCopyWithImpl<_BookSearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,publisher,pubDate,isbn13,cover,description,categoryName);

@override
String toString() {
  return 'BookSearchResult(id: $id, title: $title, author: $author, publisher: $publisher, pubDate: $pubDate, isbn13: $isbn13, cover: $cover, description: $description, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class _$BookSearchResultCopyWith<$Res> implements $BookSearchResultCopyWith<$Res> {
  factory _$BookSearchResultCopyWith(_BookSearchResult value, $Res Function(_BookSearchResult) _then) = __$BookSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? author, String? publisher, String? pubDate, String? isbn13, String? cover, String? description, String? categoryName
});




}
/// @nodoc
class __$BookSearchResultCopyWithImpl<$Res>
    implements _$BookSearchResultCopyWith<$Res> {
  __$BookSearchResultCopyWithImpl(this._self, this._then);

  final _BookSearchResult _self;
  final $Res Function(_BookSearchResult) _then;

/// Create a copy of BookSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = freezed,Object? publisher = freezed,Object? pubDate = freezed,Object? isbn13 = freezed,Object? cover = freezed,Object? description = freezed,Object? categoryName = freezed,}) {
  return _then(_BookSearchResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
