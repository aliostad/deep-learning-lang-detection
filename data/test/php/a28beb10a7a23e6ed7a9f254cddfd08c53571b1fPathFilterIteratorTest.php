<?php

namespace Bolt\Filesystem\tests\Iterator;

use Bolt\Filesystem\Adapter\Local;
use Bolt\Filesystem\Filesystem;
use Bolt\Filesystem\FilesystemInterface;
use Bolt\Filesystem\Handler\File;
use Bolt\Filesystem\Iterator\PathFilterIterator;
use Symfony\Component\Finder\Tests\Iterator\MockFileListIterator;

/**
 * Tests for Bolt\Filesystem\Iterator\PathFilterIterator
 *
 * @author Gawain Lynch <gawain.lynch@gmail.com>
 */
class PathFilterIteratorTest extends IteratorTestCase
{
    /** @var FilesystemInterface */
    protected $filesystem;

    /**
     * {@inheritdoc}
     */
    protected function setUp()
    {
        $this->filesystem = new Filesystem(new Local(__DIR__ . '/../'));
    }

    /**
     * @dataProvider getTestFilterData
     */
    public function testFilter(\Iterator $inner, array $matchPatterns, array $noMatchPatterns, array $resultArray)
    {
        $iterator = new PathFilterIterator($inner, $matchPatterns, $noMatchPatterns);
        $this->assertIterator($resultArray, $iterator);
    }

    public function getTestFilterData()
    {
        $inner = new MockFileListIterator();

        $inner[] = new File($this->filesystem, 'A/B/C/abc.dat');
        $inner[] = new File($this->filesystem, 'A/B/ab.dat');
        $inner[] = new File($this->filesystem, 'A/a.dat');
        $inner[] = new File($this->filesystem, 'copy/A/B/C/abc.dat.copy');
        $inner[] = new File($this->filesystem, 'copy/A/B/ab.dat.copy');
        $inner[] = new File($this->filesystem, 'copy/A/a.dat.copy');

        return [
            [$inner, ['/^A/'],       [],         ['A/B/C/abc.dat', 'A/B/ab.dat', 'A/a.dat']],
            [$inner, ['/^A\/B/'],    [],         ['A/B/C/abc.dat', 'A/B/ab.dat']],
            [$inner, ['/^A\/B\/C/'], [],         ['A/B/C/abc.dat']],
            [$inner, ['/A\/B\/C/'],  [],         ['A/B/C/abc.dat', 'copy/A/B/C/abc.dat.copy']],

            [$inner, ['A'],          [],         ['A/B/C/abc.dat', 'A/B/ab.dat', 'A/a.dat', 'copy/A/B/C/abc.dat.copy', 'copy/A/B/ab.dat.copy', 'copy/A/a.dat.copy']],
            [$inner, ['A/B'],        [],         ['A/B/C/abc.dat', 'A/B/ab.dat', 'copy/A/B/C/abc.dat.copy', 'copy/A/B/ab.dat.copy']],
            [$inner, ['A/B'],        [],         ['A/B/C/abc.dat', 'A/B/ab.dat', 'copy/A/B/C/abc.dat.copy', 'copy/A/B/ab.dat.copy']],
            [$inner, ['A/B/C'],      [],         ['A/B/C/abc.dat', 'copy/A/B/C/abc.dat.copy']],

            [$inner, ['copy/A'],     [],         ['copy/A/B/C/abc.dat.copy', 'copy/A/B/ab.dat.copy', 'copy/A/a.dat.copy']],
            [$inner, ['copy/A/B'],   [],         ['copy/A/B/C/abc.dat.copy', 'copy/A/B/ab.dat.copy']],
            [$inner, ['copy/A/B/C'], [],         ['copy/A/B/C/abc.dat.copy']],

            [$inner, ['A'],          ['/copy/'], ['A/B/C/abc.dat', 'A/B/ab.dat', 'A/a.dat']],
            [$inner, ['A/B'],        ['/copy/'], ['A/B/C/abc.dat', 'A/B/ab.dat']],
            [$inner, ['A/B'],        ['/copy/'], ['A/B/C/abc.dat', 'A/B/ab.dat']],
            [$inner, ['A/B/C'],      ['/copy/'], ['A/B/C/abc.dat']],
        ];
    }
}
