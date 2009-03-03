-- MySQL dump 10.11
--
-- Host: localhost    Database: parselets_com_production
-- ------------------------------------------------------
-- Server version	5.0.32-Debian_7etch8-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `content` text,
  `commentable_id` int(11) default NULL,
  `commentable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_comments_on_user_id` (`user_id`),
  KEY `commentable_poly` (`commentable_id`,`commentable_type`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_usages`
--

DROP TABLE IF EXISTS `domain_usages`;
CREATE TABLE `domain_usages` (
  `id` int(11) NOT NULL auto_increment,
  `domain_id` int(11) default NULL,
  `usage_type` varchar(255) default NULL,
  `usage_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `domain_usages_ids` (`domain_id`,`usage_id`,`usage_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `domain_usages`
--

LOCK TABLES `domain_usages` WRITE;
/*!40000 ALTER TABLE `domain_usages` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_usages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domains`
--

DROP TABLE IF EXISTS `domains`;
CREATE TABLE `domains` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `variations` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_domains_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `domains`
--

LOCK TABLES `domains` WRITE;
/*!40000 ALTER TABLE `domains` DISABLE KEYS */;
INSERT INTO `domains` VALUES (1,'www.kylemaxwell.com',' www www www.www kylemaxwell www.kylemaxwell www.kylemaxwell www.www.kylemaxwell com www.com www.com www.www.com kylemaxwell.com www.kylemaxwell.com www.kylemaxwell.com www.www.kylemaxwell.com','2009-02-16 00:59:10','2009-02-16 00:59:10'),(2,'www.yelp.com',' www www www.www yelp www.yelp www.yelp www.www.yelp com www.com www.com www.www.com yelp.com www.yelp.com www.yelp.com www.www.yelp.com','2009-02-19 04:22:11','2009-02-19 04:22:11'),(3,'www.youtube.com',' www www www.www youtube www.youtube www.youtube www.www.youtube com www.com www.com www.www.com youtube.com www.youtube.com www.youtube.com www.www.youtube.com','2009-02-19 04:47:37','2009-02-19 04:47:37'),(4,'news.ycombinator.com',' www news www.news ycombinator www.ycombinator news.ycombinator www.news.ycombinator com www.com news.com www.news.com ycombinator.com www.ycombinator.com news.ycombinator.com www.news.ycombinator.com','2009-02-25 03:54:50','2009-02-25 03:54:50'),(5,'news.google.com',' www news www.news google www.google news.google www.news.google com www.com news.com www.news.com google.com www.google.com news.google.com www.news.google.com','2009-02-26 04:48:05','2009-02-26 04:48:05');
/*!40000 ALTER TABLE `domains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitation_requests`
--

DROP TABLE IF EXISTS `invitation_requests`;
CREATE TABLE `invitation_requests` (
  `id` int(11) NOT NULL auto_increment,
  `invitation_id` int(11) default NULL,
  `email` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_invitation_requests_on_email` (`email`),
  KEY `index_invitation_requests_on_invitation_id` (`invitation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `invitation_requests`
--

LOCK TABLES `invitation_requests` WRITE;
/*!40000 ALTER TABLE `invitation_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `invitation_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitations`
--

DROP TABLE IF EXISTS `invitations`;
CREATE TABLE `invitations` (
  `id` int(11) NOT NULL auto_increment,
  `code` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `usages` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_invitations_on_code` (`code`),
  KEY `index_invitations_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `invitations`
--

LOCK TABLES `invitations` WRITE;
/*!40000 ALTER TABLE `invitations` DISABLE KEYS */;
INSERT INTO `invitations` VALUES (1,'uber',1,10,'2009-02-24 21:34:20','2009-02-24 21:34:20');
/*!40000 ALTER TABLE `invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parselet_versions`
--

DROP TABLE IF EXISTS `parselet_versions`;
CREATE TABLE `parselet_versions` (
  `id` int(11) NOT NULL auto_increment,
  `parselet_id` int(11) default NULL,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `description` text,
  `code` text,
  `pattern` varchar(255) default NULL,
  `example_url` varchar(255) default NULL,
  `domain_id` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `pattern_regex` tinyint(1) default NULL,
  `deleted_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `checked_at` datetime default NULL,
  `works` tinyint(1) default NULL,
  `cached_page_id` int(11) default NULL,
  `ratings_count` int(11) NOT NULL,
  `comments_count` int(11) NOT NULL,
  `cached_rating` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_parselet_versions_on_parselet_id_and_version` (`parselet_id`,`version`),
  KEY `index_parselet_versions_on_name` (`name`),
  KEY `index_parselet_versions_on_domain_id` (`domain_id`),
  KEY `index_parselet_versions_on_user_id` (`user_id`),
  KEY `index_parselet_versions_on_cached_page_id` (`cached_page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parselet_versions`
--

LOCK TABLES `parselet_versions` WRITE;
/*!40000 ALTER TABLE `parselet_versions` DISABLE KEYS */;
INSERT INTO `parselet_versions` VALUES (2,16,1,'test','hi','{ \"title\": \"title\" }','http://www.kylemaxwell.com/','http://www.kylemaxwell.com/',NULL,1,0,NULL,'2009-03-02 06:22:05','2009-03-02 06:22:05',1,1,0,0,0),(3,17,1,'yelp-home','world','{\r\n	\"categories(#cat_list a)\": [{\r\n		\"text\": \".\",\r\n		\"href\": \"@href\"\r\n	}]\r\n}','http://www.yelp.com/{city?}','http://www.yelp.com/','2',1,NULL,NULL,'2009-03-02 06:22:05','2009-03-02 06:22:05',1,2,0,0,0),(4,18,1,'yelp-biz','world','{ }','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,4,0,0,0),(5,18,2,'yelp-biz','world','{\r\n	\"name\": \"h1\",\r\n	\"website\": \"#bizUrl a\",\r\n	\"address\": \"address\",\r\n	\"hours\": \"#bizAdditionalInfo p\",\r\n	\"categories\": [\"#cat_display a\"],\r\n	\"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\')\",\r\n	\"review(.nonfavoriteReview)\": [{\r\n		\"reviewer\": {\r\n			\"name\": \".reviewer_name\",\r\n			\"location\": \".reviewer_name\",\r\n			\"friend_count\": \".friend_count\",\r\n			\"review_count\": \".review_count\"\r\n		},\r\n		\"date\": \".smaller\",\r\n		\"comment\": \".review_comment\",\r\n		\"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\')\"\r\n	}]\r\n}','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,4,0,0,0),(6,19,1,'youtube-browse-grid','world','{\r\n	\"video\": [{\r\n		\"thumbnail\": \"http://i1.ytimg.com/vi/xbVw7entkxg/default.jpg @src\",\r\n		\"title\": \".video-short-title a\",\r\n		\"link\": \".video-short-title a @href\",\r\n		\"posted\": \".video-date-added\",\r\n		\"views\": \".video-view-count\",\r\n		\"length\": \".video-time span\",\r\n		\"rating\": \".ratingVS @title\"\r\n	}]\r\n}','http://www.youtube.com/browse?{youtube_params}','http://www.youtube.com/browse?s=mp&c=0&l=','3',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',0,5,0,0,0),(7,20,1,'youtube-video','world','{\r\n	\"title\": \"h1\",\r\n	\"rating\": \".ratingL @title\",\r\n	\"views\": \"#watch-view-count\",\r\n	\"description\": \".description\",\r\n	\"comment_count\": \"#watch-comment-panel .expand-header-stat\",\r\n	\"comment(.watch-comment-entry)\": [{\r\n		\"user\": \".watch-comment-auth\",\r\n		\"comment\": \".watch-comment-body div\",\r\n		\"time\": \".watch-comment-time\",\r\n		\"score\": \".watch-comment-score\"\r\n	}],\r\n	\"uploader\": \".contributor\",\r\n	\"uploaded_at\": \".post-date\",\r\n	\"embed\": \"#embed_code @value\"\r\n}','http://www.youtube.com/watch?v={id}','http://www.youtube.com/watch?v=qZGz1Ajg7QU','3',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,16,0,0,0),(8,19,2,'youtube-browse-grid','Youtube\'s browse pages have a video grid.','{}','http://www.youtube.com/browse?{youtube_params}','http://www.youtube.com/browse?s=mp&c=0&l=','3',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,5,0,0,0),(9,19,3,'youtube-browse-grid','Youtube\'s browse pages have a video grid.','{ \"video(.video-cell)\": [{\"thumbnail\": \".vimg120 @src\" , \"title\": \".video-short-title a\", \"link\": \".video-short-title a @href\", \"posted\": \".video-date-added\", \"views\": \".video-view-count\", \"length\": \".video-time span\", \"rating\": \".ratingVS @title\" }]}','http://www.youtube.com/browse?{youtube_params}','http://www.youtube.com/browse?s=mp&c=0&l=','3',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,5,0,0,0),(10,18,3,'yelp-biz','A business description','{}','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,4,0,0,0),(11,21,1,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href \", \"comment_count\": \"regex:match(.subtext a:nth-child(3), \'[0-9]+\', \'\')\", \"comment_link\": \".subtext a:nth-child(3) @href\" } ] }','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,3,0,0,0),(12,21,2,'yc','hacker news','{\r\n	\"articles\": [ {\r\n			\"title\": \".title a\",\r\n			\"link\": \".title a @href \",\r\n			\"comment_count\": \"regex:match(.subtext a:nth-child(3), \'[0-9]+\', \'\')\",\r\n			\"comment_link\": \".subtext a:nth-child(3) @href\"\r\n		} ]\r\n}','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,3,0,0,0),(13,21,3,'yc','hacker news','{\r\n	\"articles\": [ {\r\n			\"title\": \".title a\",\r\n			\"link\": \".title a @href\",\r\n			\"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\', \'\'))\",\r\n			\"comment_link\": \".subtext a:nth-child(3) @href\"\r\n		} ]\r\n}','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,3,0,0,0),(14,21,4,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\', \'\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,3,0,0,0),(15,21,5,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,3,0,0,0),(16,21,6,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\', \'\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,3,0,0,0),(17,18,4,'yelp-biz','world','{\r\n	\"name\": \"h1\",\r\n	\"website\": \"#bizUrl a\",\r\n	\"address\": \"address\",\r\n	\"hours\": \"#bizAdditionalInfo p\",\r\n	\"categories\": [\"#cat_display a\"],\r\n	\"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\')\",\r\n	\"review(.nonfavoriteReview)\": [{\r\n		\"reviewer\": {\r\n			\"name\": \".reviewer_name\",\r\n			\"location\": \".reviewer_name\",\r\n			\"friend_count\": \".friend_count\",\r\n			\"review_count\": \".review_count\"\r\n		},\r\n		\"date\": \".smaller\",\r\n		\"comment\": \".review_comment\",\r\n		\"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\')\"\r\n	}]\r\n}','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,4,0,0,0),(18,18,5,'yelp-biz','world','{ \"name\": \"h1\", \"website\": \"#bizUrl a\", \"address\": \"address\", \"hours\": \"#bizAdditionalInfo p\", \"categories\": [ \"#cat_display a\" ], \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\", \"review(.nonfavoriteReview)\": [ { \"reviewer\": { \"name\": \".reviewer_name\", \"location\": \".reviewer_name\", \"friend_count\": \".friend_count\", \"review_count\": \".review_count\" }, \"date\": \".smaller\", \"comment\": \".review_comment\", \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\')\" } ] }','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,4,0,0,0),(19,18,6,'yelp-biz','world','{ \"name\": \"h1\", \"website\": \"#bizUrl a\", \"address\": \"address\", \"hours\": \"#bizAdditionalInfo p\", \"categories\": [ \"#cat_display a\" ], \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\", \"review(.nonfavoriteReview)\": [ { \"reviewer\": { \"name\": \".reviewer_name\", \"location\": \".reviewer_name\", \"friend_count\": \".friend_count\", \"review_count\": \".review_count\" }, \"date\": \".smaller\", \"comment\": \".review_comment\", \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+, \'\')\" } ] }','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',0,4,0,0,0),(20,18,7,'yelp-biz','world','{ \"name\": \"h1\", \"website\": \"#bizUrl a\", \"address\": \"address\", \"hours\": \"#bizAdditionalInfo p\", \"categories\": [ \"#cat_display a\" ], \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\", \"review(.nonfavoriteReview)\": [ { \"reviewer\": { \"name\": \".reviewer_name\", \"location\": \".reviewer_name\", \"friend_count\": \".friend_count\", \"review_count\": \".review_count\" }, \"date\": \".smaller\", \"comment\": \".review_comment\", \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\" } ] }','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:06','2009-03-02 06:22:06',1,4,0,0,0),(21,20,2,'youtube-video','Information about one youtube video','{ \"title\": \"h1\", \"rating\": \".ratingL @title\", \"views\": \"#watch-view-count\", \"description\": \".description\", \"comment_count\": \"#watch-comment-panel .expand-header-stat\", \"comment(.watch-comment-entry)\": [ { \"user\": \".watch-comment-auth\", \"comment\": \"normalize-space(.watch-comment-body div)\", \"time\": \".watch-comment-time\", \"score\": \".watch-comment-score\" } ], \"uploader\": \".contributor\", \"uploaded_at\": \".post-date\", \"embed\": \"#embed_code @value\" }','http://www.youtube.com/watch?v={id}','http://www.youtube.com/watch?v=qZGz1Ajg7QU','3',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,15,0,0,0),(22,18,8,'yelp-biz','a business description','{ \"name\": \"h1\", \"website\": \"#bizUrl a\", \"address\": \"address\", \"hours\": \"#bizAdditionalInfo p\", \"categories\": [ \"#cat_display a\" ], \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\", \"review(.nonfavoriteReview)\": [ { \"reviewer\": { \"name\": \".reviewer_name\", \"location\": \".reviewer_name\", \"friend_count\": \".friend_count\", \"review_count\": \".review_count\" }, \"date\": \".smaller\", \"comment\": \".review_comment\", \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\" } ] }','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,4,0,0,0),(23,16,2,'test','hello world for kylemaxwell.com','{ \"title\": \"title\" }','http://www.kylemaxwell.com/','http://www.kylemaxwell.com/','1',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,1,0,0,0),(24,22,1,'google-news','Google news homepage','{ \"articles(div .lh)\": [ { \"title\": \"a:nth-child(2) b\" } ] }','http://news.google.com/','http://news.google.com/','5',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,7,0,0,0),(25,16,3,'test','hello world for kylemaxwell.com','{ \"title\": \"title\", \"links\": [ \"a @href\" ] }','http://www.kylemaxwell.com/','http://www.kylemaxwell.com/','1',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,1,0,0,0),(26,17,2,'yelp-home','Categories','{\r\n	\"categories(#cat_list a)\": [{\r\n		\"text\": \".\",\r\n		\"href\": \"@href\"\r\n	}]\r\n}','http://www.yelp.com/{city?}','http://www.yelp.com/','2',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,2,0,0,0),(27,17,3,'yelp-home','Categories','{\r\n	\"categories(#cat_list a)\": [{\r\n		\"text\": \".\",\r\n		\"href\": \"@href\"\r\n	}]\r\n}','http://www.yelp.com/{city?}','http://www.yelp.com/','2',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,2,0,0,0),(28,17,4,'yelp-home','Categories','{\r\n	\"categories(#cat_list a)\": [{\r\n		\"text\": \".\",\r\n		\"href\": \"@href\"\r\n	}]\r\n}','http://www.yelp.com/{city?}','http://www.yelp.com/','2',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,2,0,0,0),(29,21,7,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\', \'\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,3,0,0,0),(30,21,8,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\', \'\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,3,0,0,0),(31,21,9,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\', \'\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/{guid?}','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,13,0,0,0),(32,21,10,'yc','hacker news','{\r\n	\"articles\": [ {\r\n			\"title\": \".title a\",\r\n			\"link\": \".title a @href\",\r\n			\"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\'))\",\r\n			\"comment_link\": \".subtext a:nth-child(3) @href\",\r\n			\"points(.subtext span)\": \"number(regex:match(., \'[0-9]+\'))\"\r\n		} ],\r\n	\"next\": \".title:nth-child(2) a @href\"\r\n}','http://news.ycombinator.com/{guid?}','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,13,0,0,0),(33,21,11,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\", \"points(.subtext span)\": \"number(regex:match(., \'[0-9]+\'))\", \"test\": \".subtext\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/{guid?}','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,13,0,0,0),(34,21,12,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\", \"points(.subtext span)\": \"number(regex:match(., \'[0-9]+\'))\", \"test(.subtext)\": \".\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/{guid?}','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,13,0,0,0),(35,21,13,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\", \"points(.subtext span)\": \"number(regex:match(., \'[0-9]+\'))\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/{guid?}','http://news.ycombinator.com/','4',1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,13,0,0,0),(36,23,1,'yc-page','comments, etc on hacker news','{ }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,44,0,0,0),(37,23,2,'yc-page','comments, etc on hacker news','{ \"title\": \".title a\", \"link\": \".title a @href\", \"comment(.default)\": [ { \"commenter\": \".comhead a:nth-child(2)\", \"permalink\": \".comhead a:nth-child(3) @href\", \"points\": \"number(regex:match(.comhead span, \'[0-9]+\'))\", \"comment\": \".\\/\\/font\", \"parent?\": \"preceding::*[@class=\'comhead\']\\/\\/a[2]\\/@href\" } ] }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,44,0,0,0),(38,23,3,'yc-page','comments, etc on hacker news','{ \"title\": \".title a\", \"link\": \".title a @href\", \"comment(.default)\": [ { \"commenter\": \".comhead a:nth-child(2)\", \"permalink\": \".comhead a:nth-child(3) @href\", \"points\": \"number(regex:match(.comhead span, \'[0-9]+\'))\", \"comment\": \".\\/\\/font\", \"parent?\": \"ancestor::*[@class=\'comhead\']\\/\\/a[2]\\/@href\" } ] }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,44,0,0,0),(39,23,4,'yc-page','comments, etc on hacker news','{ \"title\": \".title a\", \"link\": \".title a @href\", \"comment(.default)\": [ { \"commenter\": \".comhead a:nth-child(2)\", \"permalink\": \".comhead a:nth-child(3) @href\", \"points\": \"number(regex:match(.comhead span, \'[0-9]+\'))\", \"comment\": \".\\/\\/font\", \"parent?\": \"preceding::*[@class=\'comhead\']\\/\\/a[2]\\/@href\" } ] }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,44,0,0,0),(40,23,5,'yc-page','comments, etc on hacker news','{ \"title\": \".title a\", \"link\": \".title a @href\", \"comment(.default)\": [ { \"commenter\": \".comhead a:nth-child(2)\", \"permalink\": \".comhead a:nth-child(3) @href\", \"points\": \"number(regex:match(.comhead span, \'[0-9]+\'))\", \"comment\": \".\\/\\/font\", \"parent?\": [ \"preceding::*[@class=\'comhead\']\\/\\/a[2]\\/@href\" ] } ] }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,44,0,0,0),(41,23,6,'yc-page','comments, etc on hacker news','{ \"title\": \".title a\", \"link\": \".title a @href\", \"comment(.default)\": [ { \"commenter\": \".comhead a:nth-child(2)\", \"permalink\": \".comhead a:nth-child(3) @href\", \"points\": \"number(regex:match(.comhead span, \'[0-9]+\'))\", \"comment\": \".\\/\\/font\" } ] }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,44,0,0,0),(42,23,7,'yc-page','comments, etc on hacker news','{ \"title\": \".title a\", \"link\": \".title a @href\", \"comment(.default)\": [ { \"commenter\": \".comhead a:nth-child(2)\", \"permalink\": \".comhead a:nth-child(3) @href\", \"points\": \"number(regex:match(.comhead span, \'[0-9]+\'))\", \"comment\": \".\\/\\/font\" } ], \"submitter\": \".subtext a:nth-child(2)\" }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,44,0,0,0),(43,25,1,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": \"number(preceding::*[@class=\'score\'])\" } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,45,0,0,0),(44,25,2,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": \"following::*[contains(@class, \'score\')]\" } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-02 06:22:07','2009-03-02 06:22:07',1,45,0,0,0),(45,25,3,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": \"number(preceding::*[@class=\'score\'])\" } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-02 06:22:08','2009-03-02 06:22:08',1,45,0,0,0),(46,25,4,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": \"(preceding::*[@class=\'score\'])\" } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-02 06:22:08','2009-03-02 06:22:08',1,45,0,0,0),(47,25,5,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": [ \"(preceding::*[@class=\'score\'])\" ] } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-02 06:22:08','2009-03-02 06:22:08',1,45,0,0,0),(48,25,6,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": [ \"(ancestor::*[@class=\'score\'])\" ] } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-02 06:22:08','2009-03-02 06:22:08',0,45,0,0,0),(49,25,7,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": [ \"(ancestor-or-self::*[contains(@class, \'score\')])\" ] } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-02 06:22:08','2009-03-02 06:22:08',0,45,0,0,0),(50,26,1,'rpi','rpi is a rating applied to college basketball','{ }','http://www.kenpom.com/rpi.php?y={year}','http://www.kenpom.com/rpi.php?y=2009',NULL,1,NULL,NULL,'2009-03-02 06:22:08','2009-03-02 06:22:08',1,46,0,0,0);
/*!40000 ALTER TABLE `parselet_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parselets`
--

DROP TABLE IF EXISTS `parselets`;
CREATE TABLE `parselets` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `code` text,
  `pattern` varchar(255) default NULL,
  `example_url` varchar(255) default NULL,
  `domain_id` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `version` int(11) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `checked_at` datetime default NULL,
  `works` tinyint(1) default NULL,
  `cached_page_id` int(11) default NULL,
  `ratings_count` int(11) NOT NULL,
  `comments_count` int(11) NOT NULL,
  `cached_rating` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_parselets_on_name` (`name`),
  KEY `index_parselets_on_domain_id` (`domain_id`),
  KEY `index_parselets_on_user_id` (`user_id`),
  KEY `index_parselets_on_cached_page_id` (`cached_page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parselets`
--

LOCK TABLES `parselets` WRITE;
/*!40000 ALTER TABLE `parselets` DISABLE KEYS */;
INSERT INTO `parselets` VALUES (16,'test','hello world for kylemaxwell.com','{ \"title\": \"title\", \"links\": [ \"a @href\" ] }','http://www.kylemaxwell.com/','http://www.kylemaxwell.com/','1',1,3,NULL,'2009-02-16 00:33:05','2009-03-02 06:22:05','2009-03-02 06:22:05',1,9,0,0,0),(17,'yelp-home','Categories','{\r\n	\"categories(#cat_list a)\": [{\r\n		\"text\": \".\",\r\n		\"href\": \"@href\"\r\n	}]\r\n}','http://www.yelp.com/{city?}','http://www.yelp.com/','2',1,4,NULL,'2009-02-19 04:22:11','2009-03-03 01:24:05','2009-03-03 01:24:05',1,8,0,0,0),(18,'yelp-biz','a business description','{ \"name\": \"h1\", \"website\": \"#bizUrl a\", \"address\": \"address\", \"hours\": \"#bizAdditionalInfo p\", \"categories\": [ \"#cat_display a\" ], \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\", \"review(.nonfavoriteReview)\": [ { \"reviewer\": { \"name\": \".reviewer_name\", \"location\": \".reviewer_name\", \"friend_count\": \".friend_count\", \"review_count\": \".review_count\" }, \"date\": \".smaller\", \"comment\": \".review_comment\", \"rating\": \"regex:match(.rating, \'[0-9\\\\.]+\', \'\')\" } ] }','http://www.yelp.com/biz/{name}','http://www.yelp.com/biz/the-bonbonerie-cincinnati','2',1,8,NULL,'2009-02-19 04:25:19','2009-03-03 01:21:01','2009-03-03 01:21:01',0,10,0,0,0),(19,'youtube-browse-grid','Youtube\'s browse pages have a video grid.','{ \"video(.video-cell)\": [{\"thumbnail\": \".vimg120 @src\" , \"title\": \".video-short-title a\", \"link\": \".video-short-title a @href\", \"posted\": \".video-date-added\", \"views\": \".video-view-count\", \"length\": \".video-time span\", \"rating\": \".ratingVS @title\" }]}','http://www.youtube.com/browse?{youtube_params}','http://www.youtube.com/browse?s=mp&c=0&l=','3',1,3,NULL,'2009-02-19 04:47:37','2009-03-03 01:18:58','2009-03-03 01:18:58',1,11,0,0,0),(20,'youtube-video','Information about one youtube video','{ \"title\": \"h1\", \"rating\": \".ratingL @title\", \"views\": \"#watch-view-count\", \"description\": \".description\", \"comment_count\": \"#watch-comment-panel .expand-header-stat\", \"comment(.watch-comment-entry)\": [ { \"user\": \".watch-comment-auth\", \"comment\": \"normalize-space(.watch-comment-body div)\", \"time\": \".watch-comment-time\", \"score\": \".watch-comment-score\" } ], \"uploader\": \".contributor\", \"uploaded_at\": \".post-date\", \"embed\": \"#embed_code @value\" }','http://www.youtube.com/watch?v={id}','http://www.youtube.com/watch?v=qZGz1Ajg7QU','3',1,2,NULL,'2009-02-19 04:54:08','2009-03-02 06:22:05','2009-03-02 06:22:05',1,12,0,0,0),(21,'yc','hacker news','{ \"articles\": [ { \"title\": \".title a\", \"link\": \".title a @href\", \"comment_count(.subtext a:nth-child(3))\": \"number(regex:match(., \'[0-9]+\'))\", \"comment_link\": \".subtext a:nth-child(3) @href\", \"points(.subtext span)\": \"number(regex:match(., \'[0-9]+\'))\" } ], \"next\": \".title:nth-child(2) a @href\" }','http://news.ycombinator.com/{guid?}','http://news.ycombinator.com/','4',1,13,NULL,'2009-02-25 03:54:50','2009-03-02 06:22:05','2009-03-02 06:22:05',1,13,0,0,0),(22,'google-news','Google news homepage','{ \"articles(div .lh)\": [ { \"title\": \"a:nth-child(2) b\" } ] }','http://news.google.com/','http://news.google.com/','5',1,1,NULL,'2009-02-26 04:48:05','2009-03-02 06:22:05','2009-03-02 06:22:05',0,14,0,0,0),(23,'yc-page','comments, etc on hacker news','{ \"title\": \".title a\", \"link\": \".title a @href\", \"comment(.default)\": [ { \"commenter\": \".comhead a:nth-child(2)\", \"permalink\": \".comhead a:nth-child(3) @href\", \"points\": \"number(regex:match(.comhead span, \'[0-9]+\'))\", \"comment\": \".\\/\\/font\" } ], \"submitter\": \".subtext a:nth-child(2)\" }','http://news.ycombinator.com/item?id={id}','http://news.ycombinator.com/item?id=498244',NULL,1,7,NULL,'2009-03-01 01:44:53','2009-03-02 06:22:05','2009-03-02 06:22:05',1,44,0,0,0),(24,'reddit-home','home page of reddit','{ \"entry\": \"\" }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,NULL,NULL,'2009-03-01 02:04:29','2009-03-02 06:22:05','2009-03-02 06:22:05',1,45,0,0,0),(25,'reddit-home1','home page of reddit','{ \"entry(.entry)\": [ { \"title\": \"a\", \"link\": \"a @href\", \"comments\": \".comments @href\", \"comment_count\": \"number(regexp:match(.comments, \'[0-9]+\'))\", \"author\": \".author\", \"points\": [ \"(ancestor-or-self::*[contains(@class, \'score\')])\" ] } ] }','http://www.reddit.com/','http://www.reddit.com/',NULL,1,7,NULL,'2009-03-01 02:07:45','2009-03-02 06:22:05','2009-03-02 06:22:05',0,45,0,0,0),(26,'rpi','rpi is a rating applied to college basketball','{ }','http://www.kenpom.com/rpi.php?y={year}','http://www.kenpom.com/rpi.php?y=2009',NULL,1,1,NULL,'2009-03-01 08:58:36','2009-03-03 01:20:46','2009-03-03 01:20:46',1,46,0,0,0);
/*!40000 ALTER TABLE `parselets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_requests`
--

DROP TABLE IF EXISTS `password_requests`;
CREATE TABLE `password_requests` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `sent_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_password_requests_on_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `password_requests`
--

LOCK TABLES `password_requests` WRITE;
/*!40000 ALTER TABLE `password_requests` DISABLE KEYS */;
INSERT INTO `password_requests` VALUES (1,'kyle@kylemaxwell.com','2009-02-26 19:03:07','2009-02-26 19:03:07','2009-02-26 19:03:07'),(2,'kyle@kylemaxwell.com','2009-02-26 19:08:37','2009-02-26 19:08:37','2009-02-26 19:08:37'),(3,'kyle@kylemaxwell.com','2009-02-26 19:14:24','2009-02-26 19:14:24','2009-02-26 19:14:24'),(4,'kyle@kylemaxwell.com','2009-02-26 19:18:54','2009-02-26 19:18:54','2009-02-26 19:18:54');
/*!40000 ALTER TABLE `password_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `score` int(11) default NULL,
  `ratable_id` int(11) default NULL,
  `ratable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_ratings_on_user_id` (`user_id`),
  KEY `index_ratings_on_ratable_id_and_ratable_type` (`ratable_id`,`ratable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
INSERT INTO `ratings` VALUES (1,1,1,26,'Parselet','2009-03-03 01:10:26','2009-03-03 01:10:26'),(2,1,1,16,'Parselet','2009-03-03 01:10:26','2009-03-03 01:10:26'),(3,1,4,19,'Parselet','2009-03-03 01:10:28','2009-03-03 01:10:28'),(4,1,3,20,'Parselet','2009-03-03 01:10:30','2009-03-03 01:10:30'),(5,1,2,17,'Parselet','2009-03-03 01:10:32','2009-03-03 01:10:32');
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20090209033631'),('20090209035448'),('20090209052803'),('20090209053100'),('20090209053526'),('20090216001315'),('20090216002219'),('20090216044342'),('20090219034601'),('20090224184124'),('20090224184553'),('20090225020554'),('20090225181851'),('20090226051637'),('20090226175859'),('20090226232843'),('20090228003220'),('20090228015131'),('20090228202242'),('20090228203138'),('20090302225138'),('20090303061246'),('20090303061503'),('20090303062716');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprig_usages`
--

DROP TABLE IF EXISTS `sprig_usages`;
CREATE TABLE `sprig_usages` (
  `id` int(11) NOT NULL auto_increment,
  `sprig_id` int(11) default NULL,
  `sprig_version_id` int(11) default NULL,
  `parselet_id` int(11) default NULL,
  `parselet_version_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `sprig_usages_ids` (`sprig_id`,`sprig_version_id`,`parselet_id`,`parselet_version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sprig_usages`
--

LOCK TABLES `sprig_usages` WRITE;
/*!40000 ALTER TABLE `sprig_usages` DISABLE KEYS */;
/*!40000 ALTER TABLE `sprig_usages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprig_versions`
--

DROP TABLE IF EXISTS `sprig_versions`;
CREATE TABLE `sprig_versions` (
  `id` int(11) NOT NULL auto_increment,
  `sprig_id` int(11) default NULL,
  `version` int(11) default NULL,
  `name` varchar(255) default NULL,
  `description` text,
  `code` text,
  `user_id` int(11) default NULL,
  `deleted_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_sprig_versions_on_sprig_id_and_version` (`sprig_id`,`version`),
  KEY `index_sprig_versions_on_name` (`name`),
  KEY `index_sprig_versions_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sprig_versions`
--

LOCK TABLES `sprig_versions` WRITE;
/*!40000 ALTER TABLE `sprig_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sprig_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprigs`
--

DROP TABLE IF EXISTS `sprigs`;
CREATE TABLE `sprigs` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `code` text,
  `user_id` int(11) default NULL,
  `version` int(11) default NULL,
  `deleted_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_sprigs_on_name` (`name`),
  KEY `index_sprigs_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sprigs`
--

LOCK TABLES `sprigs` WRITE;
/*!40000 ALTER TABLE `sprigs` DISABLE KEYS */;
/*!40000 ALTER TABLE `sprigs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thumbnails`
--

DROP TABLE IF EXISTS `thumbnails`;
CREATE TABLE `thumbnails` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `tries` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_thumbnails_on_url` (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `thumbnails`
--

LOCK TABLES `thumbnails` WRITE;
/*!40000 ALTER TABLE `thumbnails` DISABLE KEYS */;
INSERT INTO `thumbnails` VALUES (13,'http://www.yelp.com','2009-02-28 01:30:59','2009-02-28 01:30:59',NULL),(14,'http://www.yelp.com/','2009-02-28 01:31:02','2009-02-28 01:31:02',NULL),(15,'http://www.yelp.com/biz/the-bonbonerie-cincinnati','2009-02-28 01:31:03','2009-02-28 01:31:03',NULL),(16,'http://www.youtube.com','2009-02-28 01:31:03','2009-02-28 01:31:03',NULL),(17,'http://www.youtube.com/browse?s=mp&c=0&l=','2009-02-28 01:31:03','2009-02-28 01:31:03',NULL),(18,'http://www.youtube.com/watch?v=qZGz1Ajg7QU','2009-02-28 01:31:03','2009-02-28 01:31:03',NULL),(19,'http://www.kylemaxwell.com','2009-02-28 01:31:03','2009-03-02 23:01:51',1),(20,'http://www.kylemaxwell.com/','2009-02-28 01:31:04','2009-03-01 00:07:20',1),(21,'http://news.ycombinator.com','2009-02-28 01:31:04','2009-02-28 01:31:04',NULL),(22,'http://news.ycombinator.com/','2009-02-28 01:31:04','2009-02-28 01:31:04',NULL),(23,'http://news.google.com','2009-02-28 01:31:04','2009-02-28 01:31:04',NULL),(24,'http://news.google.com/','2009-02-28 01:31:05','2009-02-28 01:31:05',NULL),(25,'http://news.ycombinator.com/item?id=498244','2009-03-01 01:44:54','2009-03-01 01:44:54',NULL),(26,'http://www.reddit.com/','2009-03-01 02:07:46','2009-03-01 02:07:46',NULL),(27,'http://www.kenpom.com/rpi.php?y=2009','2009-03-01 08:58:37','2009-03-01 08:58:37',NULL);
/*!40000 ALTER TABLE `thumbnails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(40) default NULL,
  `name` varchar(100) default '',
  `email` varchar(100) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(40) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `admin` tinyint(1) default '0',
  `invitation_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_login` (`login`),
  UNIQUE KEY `index_users_on_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'kyle','','kyle@kylemaxwell.com','637f1cbc5b8452514abce35fed364a6edd87e471','241a38ae16e64d267b106f5279c33447cd0a2612','2009-02-12 06:04:43','2009-02-24 21:34:06',NULL,NULL,1,NULL),(2,'andrew','','andrew@andrewcantino.com','ab0e3daaeca6db043165ad53633893b399fb1dfc','b3b59d5aae6cda58af21d9bfded6b8f8084b016a','2009-02-25 22:26:46','2009-02-25 22:26:46',NULL,NULL,0,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-03-03  9:18:47
