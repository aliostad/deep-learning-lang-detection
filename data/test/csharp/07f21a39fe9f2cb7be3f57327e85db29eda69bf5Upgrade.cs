using UnityEngine;
using System.Collections;

public class Upgrade : MonoBehaviour
{
    public gameController _gameController;

    public void onTap ()
    {
	    if(_gameController._score>= _gameController._upgradePrice)
        {
            _gameController._score=_gameController._score - _gameController._upgradePrice;
            _gameController._tapPower = _gameController._tapPower + _gameController._increase;
            _gameController._increase = _gameController._increase * 2;
            _gameController._upgradePrice = _gameController._upgradePrice * 2;
        }
	}
}
