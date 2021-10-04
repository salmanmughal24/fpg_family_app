import 'package:xml/src/xml/nodes/element.dart';

class FeedsItem{
  var title;
  var link;
  var comments;
  var creator;
  var pubDate;
  var category;
  var guid;
  var description;
  var contentEncoded;
  var commentrss;
  var slashComments;
  var id;

  FeedsItem(this.title);

  FeedsItem.fromElement(XmlElement item) {
    this.title = item.getElement('title')?.text;
    this.link = item.getElement('link')?.text;
    this.comments = item.getElement('comments')?.text;
    this.creator = item.getElement('dc:creator')?.text;
    this.pubDate = item.getElement('pubdate')?.text;
    this.category = item.getElement('category')?.text;
    this.guid = item.getElement('guid')?.text;
    // this.description = item.getElement('description');
    this.description = item.getElement('description')?.text;
    this.contentEncoded = item.getElement('content:encoded')?.text;
    this.commentrss = item.getElement('wfw:commentrss')?.text;
    this.slashComments = item.getElement('slash:comments')?.text;
    this.id = item.getElement('post-id')?.text;
  }
}