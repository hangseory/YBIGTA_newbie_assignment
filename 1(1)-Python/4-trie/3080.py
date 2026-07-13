from lib import Trie
import sys


"""
TODO:
- 일단 lib.py의 Trie Class부터 구현하기
- main 구현하기

힌트: 한 글자짜리 자료에도 그냥 str을 쓰기에는 메모리가 아깝다...
"""

def main() -> None:
    # 구현하세요!
    MOD = 1_000_000_007
    n = int(input())

    trie: Trie[int] = Trie()

    for _ in range(n):
        name = input().strip()
        trie.push(map(ord, name))

    answer = 1

    for node in trie:
        group_count = len(node.children)

        if node.is_end:
            group_count += 1

        factorial_value = 1

        for i in range(2, group_count + 1):
            factorial_value = factorial_value * i % MOD

        answer = answer * factorial_value % MOD

    print(answer)

if __name__ == "__main__":
    main()