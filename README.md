# itsruin_entitiyHealthManager
Entitiy Health (Damage) & Freeze Manager for FiveM (Standalone)

## 소개
인게임에 존재하는 특정 오브젝트를 무적 상태로 만들고 움직이지 않도록 고정하는 시스템입니다.<br/>
멀리서 신호등이 아무 이유없이 부서지는 고질적인 문제를 해결합니다.<br/>
또한 국내의 경우 보석상 야자수 나무, 교도소 기름통 등에 유용하게 쓰일 수 있습니다.

## 설정 방법
1. 지정하고자 하는 오브젝트의 이름을 찾습니다. (GTA 온라인 오브젝트의 경우 https://gtahash.ru/ 에서 찾으실 수 있습니다.)
2. 찾은 오브젝트의 이름을 `lua/client/config.lua`에 추가하여 적용합니다.

```lua
config.props = {
	"오브젝트 이름 입력",
}
```

## 참고자료
- entityEnumerator (entityiter.lua) :: https://gist.github.com/IS4Code
