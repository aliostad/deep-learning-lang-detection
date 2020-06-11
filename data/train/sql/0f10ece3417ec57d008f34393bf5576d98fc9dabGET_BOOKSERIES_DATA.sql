CREATE OR REPLACE DIRECTORY EXPORT_DIR
AS
  '/u03/app/oracle/flash_recovery_area/backups/AJDF1DB9/exp';
  GRANT read, write ON DIRECTORY EXPORT_DIR TO PUBLIC;
  DECLARE
    doc xmldom.DOMDocument;
    pubidhold NUMBER;
    main_node xmldom.DOMNode;
    root_node xmldom.DOMNode;
    user_node xmldom.DOMNode;
    item_node xmldom.DOMNode;
    root_elmt xmldom.DOMElement;
    item_elmt xmldom.DOMElement;
    item_text xmldom.DOMText;
    v_previous_pubid NUMBER;
    CURSOR get_series
    IS
      SELECT a.pubid ,
        a.doi ,
        a.area,
        c.title
      FROM PUBLICATION a,
        PUB_SERIAL b,
        PUB_TITLE c
      WHERE a.PUBID     = b.PUBID
      AND a.pubid       =c.pubid
      AND a.PUBAGENTTYPE=106;
    CURSOR get_books
    IS
      SELECT PUBLICATION.pubid,
        PUBLICATION.doi,
        PUBLICATION.area,
        pub_title.title
      FROM PUBLICATION ,
        BOOK_META ,
        pub_title
      WHERE PUBLICATION.pubid            = pub_title.pubid(+)
      AND publication.PUBID              = BOOK_META.PUBID
      AND publication.PUBAGENTTYPE      IN (105,112)
      AND BITAND(PUBLICATION.AREA,16400) = 0
      AND (BOOK_META.bookParentId        = pubidhold
      OR EXISTS
        (SELECT *
        FROM book_meta parents
        WHERE parents.pubId      = BOOK_META.bookParentId
        AND parents.bookParentId = pubidhold
        ))
      ORDER BY PUBLICATION.DOI;
    BEGIN
      -- get document
      doc := xmldom.newDOMDocument;
      -- create root element
      main_node          := xmldom.makeNode(doc);
      root_elmt          := xmldom.createElement( doc , 'bookseriesdata' );
      root_node          := xmldom.appendChild( main_node , xmldom.makeNode(root_elmt) );
      FOR get_series_rec IN get_series
      LOOP
        item_elmt := xmldom.createElement( doc , 'bookseries' );
        xmldom.setAttribute( item_elmt , 'pubid' , get_series_rec.pubid );
        user_node := xmldom.appendChild( root_node , xmldom.makeNode(item_elmt) );
        --
        item_elmt := xmldom.createElement( doc , 'doi' );
        item_node := xmldom.appendChild( user_node , xmldom.makeNode(item_elmt) );
        item_text := xmldom.createTextNode( doc , get_series_rec.doi );
        item_node := xmldom.appendChild( item_node , xmldom.makeNode(item_text) );
        --
        item_elmt        := xmldom.createElement( doc , 'area' );
        item_node        := xmldom.appendChild( user_node , xmldom.makeNode(item_elmt) );
        item_text        := xmldom.createTextNode( doc , get_series_rec.area );
        item_node        := xmldom.appendChild( item_node , xmldom.makeNode(item_text) );
        item_elmt        := xmldom.createElement( doc , 'title' );
        item_node        := xmldom.appendChild( user_node , xmldom.makeNode(item_elmt) );
        item_text        := xmldom.createTextNode( doc , get_series_rec.title );
        item_node        := xmldom.appendChild( item_node , xmldom.makeNode(item_text) );
        pubidhold        := get_series_rec.pubid;
        v_previous_pubid :=0;
        --get books
        FOR book_rec IN
        (SELECT PUBLICATION.pubid,
          PUBLICATION.doi,
          PUBLICATION.area,
          pub_title.title
        FROM PUBLICATION ,
          BOOK_META ,
          pub_title
        WHERE PUBLICATION.pubid            = pub_title.pubid(+)
        AND publication.PUBID              = BOOK_META.PUBID
        AND publication.PUBAGENTTYPE      IN (105,112)
        AND BITAND(PUBLICATION.AREA,16400) = 0
        AND (BOOK_META.bookParentId        = pubidhold
        OR EXISTS
          (SELECT *
          FROM book_meta parents
          WHERE parents.pubId      = BOOK_META.bookParentId
          AND parents.bookParentId = pubidhold
          ))
        ORDER BY PUBLICATION.DOI
        )
        LOOP
          --note that there isn't a single title for a book, usually there is at least an XML version 
          --and a plain text version.  I just want a title for debug purposes
          IF v_previous_pubid != book_rec.pubid THEN
            v_previous_pubid  := book_rec.pubid;
            item_elmt         := xmldom.createElement( doc , 'book' );
            xmldom.setAttribute( item_elmt , 'pubid' , book_rec.pubid );
            item_node := xmldom.appendChild( user_node , xmldom.makeNode(item_elmt) );
            item_elmt := xmldom.createElement( doc , 'doi' );
            item_node := xmldom.appendChild( user_node , xmldom.makeNode(item_elmt) );
            item_text := xmldom.createTextNode( doc , book_rec.doi );
            item_node := xmldom.appendChild( item_node , xmldom.makeNode(item_text) );
            --
            item_elmt := xmldom.createElement( doc , 'area' );
            item_node := xmldom.appendChild( user_node , xmldom.makeNode(item_elmt) );
            item_text := xmldom.createTextNode( doc , book_rec.area );
            item_node := xmldom.appendChild( item_node , xmldom.makeNode(item_text) );
            item_elmt := xmldom.createElement( doc , 'title' );
            item_node := xmldom.appendChild( user_node , xmldom.makeNode(item_elmt) );
            item_text := xmldom.createTextNode( doc , book_rec.title );
            item_node := xmldom.appendChild( item_node , xmldom.makeNode(item_text) );
          END IF;
        END LOOP;
      END LOOP;
      -- write document to file using default character set from database
      xmldom.writeToFile(doc , 'EXPORT_DIR/books.xml',xmldom.getCharset(doc));
      xmldom.freeDocument(doc);
      -- deal with exceptions
    EXCEPTION
    WHEN xmldom.INDEX_SIZE_ERR THEN
      raise_application_error(-20120, 'Index Size error');
    WHEN xmldom.DOMSTRING_SIZE_ERR THEN
      raise_application_error(-20120, 'String Size error');
    WHEN xmldom.HIERARCHY_REQUEST_ERR THEN
      raise_application_error(-20120, 'Hierarchy request error');
    WHEN xmldom.WRONG_DOCUMENT_ERR THEN
      raise_application_error(-20120, 'Wrong doc error');
    WHEN xmldom.INVALID_CHARACTER_ERR THEN
      raise_application_error(-20120, 'Invalid Char error');
    WHEN xmldom.NO_DATA_ALLOWED_ERR THEN
      raise_application_error(-20120, 'Nod data allowed error');
    WHEN xmldom.NOT_FOUND_ERR THEN
      raise_application_error(-20120, 'Not found error');
    WHEN xmldom.NOT_SUPPORTED_ERR THEN
      raise_application_error(-20120, 'Not supported error');
    WHEN xmldom.INUSE_ATTRIBUTE_ERR THEN
      raise_application_error(-20120, 'In use attr error');
    END;
    .
    run;
