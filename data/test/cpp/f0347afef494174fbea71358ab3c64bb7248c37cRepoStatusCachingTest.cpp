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



class RepoStatusCachingTest : public GitTestBase
{
	Q_OBJECT

	private slots:
		void initTestCase() {
			GitTestBase::initTestCase();

			cloneFrom("RepoStatusCachingTestRepo");
		}



		void testStatusCachingSame() {
			QVERIFY(repo->d->commits.isEmpty());

			Git::Status *status1 = repo->status();
			QCOMPARE(status1->files().size(), 1);
			QVERIFY(repo->d->status != 0);

			Git::Status *status2 = repo->status();
			QCOMPARE(status2->files().size(), 1);
			QVERIFY(repo->d->status != 0);

			QVERIFY(status1 == status2);
		}

		void testStatusReset() {
			QVERIFY(repo->d->status == 0);

			repo->status();
			QVERIFY(repo->d->status != 0);

			repo->resetStatus();
			QVERIFY(repo->d->status == 0);
		}

		void testReset() {
			QVERIFY(repo->d->status == 0);

			repo->status();
			QVERIFY(repo->d->status != 0);

			repo->reset();
			QVERIFY(repo->d->status == 0);
		}
};

QTEST_KDEMAIN_CORE(RepoStatusCachingTest)

#include "RepoStatusCachingTest.moc"
