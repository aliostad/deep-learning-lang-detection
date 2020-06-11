<?php

namespace DumpScan\Views;

use DumpScan\DumpScan;
use HtmlObject\Element;
use Mediawiki\Dump\DumpQuery;

class DumpScanView {

	protected $dumpScan;

	/**
	 * @param DumpScan $dumpScan
	 */
	public function __construct( DumpScan $dumpScan ) {
		$this->dumpScan = $dumpScan;
	}

	public function getHtml() {
		$html = '';
		$html .= Element::create( 'p', 'Scan of: ' . $this->dumpScan->getTarget() );
		$html .= Element::create( 'p', 'Namespaces: ' . implode( ', ', $this->dumpScan->getQuery()->getNamespaceFilters() ) );
		$html .= Element::create( 'p', 'TitleContains: ' . implode( ', ', $this->dumpScan->getQuery()->getTitleFilters( DumpQuery::TYPE_CONTAINS ) ) );
		$html .= Element::create( 'p', 'TitleMissing: ' . implode( ', ', $this->dumpScan->getQuery()->getTitleFilters( DumpQuery::TYPE_MISSING ) ) );
		$html .= Element::create( 'p', 'TextContains: ' . implode( ', ', $this->dumpScan->getQuery()->getTextFilters( DumpQuery::TYPE_CONTAINS ) ) );
		$html .= Element::create( 'p', 'TextMissing: ' . implode( ', ', $this->dumpScan->getQuery()->getTextFilters( DumpQuery::TYPE_MISSING ) ) );
		return $html;
	}

} 