// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Book {

 String get id; String get title; String? get author; String? get publisher;@JsonKey(name: 'pub_date') String? get pubDate; String? get isbn13;@JsonKey(name: 'cover_url') String? get coverUrl; String? get description;@JsonKey(name: 'category_name') String? get categoryName; ReadingStatus get status; int? get rating; String? get notes;@JsonKey(name: 'current_page') int? get currentPage;@JsonKey(name: 'total_page') int? get totalPage;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'representative_sentence') String? get representativeSentence;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.status, status) || other.status == status)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPage, totalPage) || other.totalPage == totalPage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.representativeSentence, representativeSentence) || other.representativeSentence == representativeSentence));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,publisher,pubDate,isbn13,coverUrl,description,categoryName,status,rating,notes,currentPage,totalPage,createdAt,representativeSentence);

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, publisher: $publisher, pubDate: $pubDate, isbn13: $isbn13, coverUrl: $coverUrl, description: $description, categoryName: $categoryName, status: $status, rating: $rating, notes: $notes, currentPage: $currentPage, totalPage: $totalPage, createdAt: $createdAt, representativeSentence: $representativeSentence)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? author, String? publisher,@JsonKey(name: 'pub_date') String? pubDate, String? isbn13,@JsonKey(name: 'cover_url') String? coverUrl, String? description,@JsonKey(name: 'category_name') String? categoryName, ReadingStatus status, int? rating, String? notes,@JsonKey(name: 'current_page') int? currentPage,@JsonKey(name: 'total_page') int? totalPage,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'representative_sentence') String? representativeSentence
});




}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = freezed,Object? publisher = freezed,Object? pubDate = freezed,Object? isbn13 = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? categoryName = freezed,Object? status = null,Object? rating = freezed,Object? notes = freezed,Object? currentPage = freezed,Object? totalPage = freezed,Object? createdAt = null,Object? representativeSentence = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,currentPage: freezed == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int?,totalPage: freezed == totalPage ? _self.totalPage : totalPage // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,representativeSentence: freezed == representativeSentence ? _self.representativeSentence : representativeSentence // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Book].
extension BookPatterns on Book {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? author,  String? publisher, @JsonKey(name: 'pub_date')  String? pubDate,  String? isbn13, @JsonKey(name: 'cover_url')  String? coverUrl,  String? description, @JsonKey(name: 'category_name')  String? categoryName,  ReadingStatus status,  int? rating,  String? notes, @JsonKey(name: 'current_page')  int? currentPage, @JsonKey(name: 'total_page')  int? totalPage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'representative_sentence')  String? representativeSentence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.publisher,_that.pubDate,_that.isbn13,_that.coverUrl,_that.description,_that.categoryName,_that.status,_that.rating,_that.notes,_that.currentPage,_that.totalPage,_that.createdAt,_that.representativeSentence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? author,  String? publisher, @JsonKey(name: 'pub_date')  String? pubDate,  String? isbn13, @JsonKey(name: 'cover_url')  String? coverUrl,  String? description, @JsonKey(name: 'category_name')  String? categoryName,  ReadingStatus status,  int? rating,  String? notes, @JsonKey(name: 'current_page')  int? currentPage, @JsonKey(name: 'total_page')  int? totalPage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'representative_sentence')  String? representativeSentence)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.title,_that.author,_that.publisher,_that.pubDate,_that.isbn13,_that.coverUrl,_that.description,_that.categoryName,_that.status,_that.rating,_that.notes,_that.currentPage,_that.totalPage,_that.createdAt,_that.representativeSentence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? author,  String? publisher, @JsonKey(name: 'pub_date')  String? pubDate,  String? isbn13, @JsonKey(name: 'cover_url')  String? coverUrl,  String? description, @JsonKey(name: 'category_name')  String? categoryName,  ReadingStatus status,  int? rating,  String? notes, @JsonKey(name: 'current_page')  int? currentPage, @JsonKey(name: 'total_page')  int? totalPage, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'representative_sentence')  String? representativeSentence)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.publisher,_that.pubDate,_that.isbn13,_that.coverUrl,_that.description,_that.categoryName,_that.status,_that.rating,_that.notes,_that.currentPage,_that.totalPage,_that.createdAt,_that.representativeSentence);case _:
  return null;

}
}

}

/// @nodoc


class _Book implements Book {
  const _Book({required this.id, required this.title, this.author, this.publisher, @JsonKey(name: 'pub_date') this.pubDate, this.isbn13, @JsonKey(name: 'cover_url') this.coverUrl, this.description, @JsonKey(name: 'category_name') this.categoryName, this.status = ReadingStatus.wantToRead, this.rating, this.notes, @JsonKey(name: 'current_page') this.currentPage, @JsonKey(name: 'total_page') this.totalPage, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'representative_sentence') this.representativeSentence});
  

@override final  String id;
@override final  String title;
@override final  String? author;
@override final  String? publisher;
@override@JsonKey(name: 'pub_date') final  String? pubDate;
@override final  String? isbn13;
@override@JsonKey(name: 'cover_url') final  String? coverUrl;
@override final  String? description;
@override@JsonKey(name: 'category_name') final  String? categoryName;
@override@JsonKey() final  ReadingStatus status;
@override final  int? rating;
@override final  String? notes;
@override@JsonKey(name: 'current_page') final  int? currentPage;
@override@JsonKey(name: 'total_page') final  int? totalPage;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'representative_sentence') final  String? representativeSentence;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.status, status) || other.status == status)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPage, totalPage) || other.totalPage == totalPage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.representativeSentence, representativeSentence) || other.representativeSentence == representativeSentence));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,publisher,pubDate,isbn13,coverUrl,description,categoryName,status,rating,notes,currentPage,totalPage,createdAt,representativeSentence);

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, publisher: $publisher, pubDate: $pubDate, isbn13: $isbn13, coverUrl: $coverUrl, description: $description, categoryName: $categoryName, status: $status, rating: $rating, notes: $notes, currentPage: $currentPage, totalPage: $totalPage, createdAt: $createdAt, representativeSentence: $representativeSentence)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? author, String? publisher,@JsonKey(name: 'pub_date') String? pubDate, String? isbn13,@JsonKey(name: 'cover_url') String? coverUrl, String? description,@JsonKey(name: 'category_name') String? categoryName, ReadingStatus status, int? rating, String? notes,@JsonKey(name: 'current_page') int? currentPage,@JsonKey(name: 'total_page') int? totalPage,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'representative_sentence') String? representativeSentence
});




}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = freezed,Object? publisher = freezed,Object? pubDate = freezed,Object? isbn13 = freezed,Object? coverUrl = freezed,Object? description = freezed,Object? categoryName = freezed,Object? status = null,Object? rating = freezed,Object? notes = freezed,Object? currentPage = freezed,Object? totalPage = freezed,Object? createdAt = null,Object? representativeSentence = freezed,}) {
  return _then(_Book(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReadingStatus,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,currentPage: freezed == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int?,totalPage: freezed == totalPage ? _self.totalPage : totalPage // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,representativeSentence: freezed == representativeSentence ? _self.representativeSentence : representativeSentence // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
