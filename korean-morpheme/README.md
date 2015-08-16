## Korean Morpheme

[은전한닢](https://bitbucket.org/eunjeon/mecab-ko)을 설치한 도커 이미지

추가로 N42에서 공개한 [사용자 사전](https://github.com/n42corp/search-ko-dic) 반영

### Usage

  docker run -it --rm n42corp/korean-morpheme

```
➜ docker run -it --rm n42corp/korean-morpheme
안녕하세요
안녕  NNG,*,T,안녕,*,*,*,*
하 XSV,*,F,하,*,*,*,*
세요  EP+EF,*,F,세요,Inflect,EP,EF,시/EP/*+어요/EF/*
EOS
```

### Build

  touch cache-buster && docker build -t n42corp/korean-morpheme .

`cache-buster` for latest user dic

https://github.com/docker/docker/pull/10682#issuecomment-73777340

