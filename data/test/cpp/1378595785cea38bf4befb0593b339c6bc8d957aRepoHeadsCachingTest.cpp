/*
	Cocoon - A GUI for Git.
	Copyright (C) 2009  Riyad Preukschas <riyad@informatik.uni-bremen.de>

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "GitTestBase.h"

#include "Git/Repo_p.h"



class RepoHeadsCachingTest : public GitTestBase
{
	Q_OBJECT

	private slots:
		void initTestCase() {
			GitTestBase::initTestCase();

			cloneFrom("RepoHeadsCachingTestRepo");
		}



		void shouldCacheHeads() {
			QVERIFY(repo->d->refs.isEmpty());

			QList<Git::Ref> heads1 = repo->heads();
			QCOMPARE(heads1.size(), 1);
			QCOMPARE(repo->d->refs.size(), 1);

			QList<Git::Ref> heads2 = repo->heads();
			QCOMPARE(heads2.size(), 1);
			QCOMPARE(repo->d->refs.size(), 1);

			QCOMPARE(heads2, heads1);
		}

		void testHeadsReset() {
			QVERIFY(repo->d->refs.isEmpty());

			repo->heads();
			QVERIFY(!repo->d->refs.isEmpty());

			repo->resetRefs();
			QVERIFY(repo->d->refs.isEmpty());
		}

		void testReset() {
			QVERIFY(repo->d->refs.isEmpty());

			repo->heads();
			QVERIFY(!repo->d->refs.isEmpty());

			repo->reset();
			QVERIFY(repo->d->refs.isEmpty());
		}
};

QTEST_KDEMAIN_CORE(RepoHeadsCachingTest)

#include "RepoHeadsCachingTest.moc"
