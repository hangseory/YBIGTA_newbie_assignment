
# anaconda(또는 miniconda)가 존재하지 않을 경우 설치해주세요!
## TODO
if command -v conda > /dev/null 2>&1; then
    CONDA_BASE=$(conda info --base)

elif [ -d "$HOME/miniconda3" ]; then
    CONDA_BASE="$HOME/miniconda3"

else
    echo "[INFO] Miniconda를 설치합니다."

    wget -q \
        https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
        -O /tmp/miniconda.sh

    bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"
    rm /tmp/miniconda.sh

    CONDA_BASE="$HOME/miniconda3"

fi

source "$CONDA_BASE/etc/profile.d/conda.sh"

conda tos accept --override-channels \
    --channel https://repo.anaconda.com/pkgs/main

conda tos accept --override-channels \
    --channel https://repo.anaconda.com/pkgs/r

conda create -y -n myenv python=3.11
conda activate myenv

# Conda 환셩 생성 및 활성화
## TODO
if ! conda env list | awk '{print $1}' | grep -qx "myenv"; then
    echo "[INFO] myenv 가상환경을 생성합니다."
    conda create -y -n myenv python=3.11
fi

## 건드리지 마세요! ##
python_env=$(python -c "import sys; print(sys.prefix)")
if [[ "$python_env" == *"/envs/myenv"* ]]; then
    echo "[INFO] 가상환경 활성화: 성공"
else
    echo "[INFO] 가상환경 활성화: 실패"
    exit 1 
fi

# 필요한 패키지 설치
## TODO

python -m pip install --upgrade pip
python -m pip install mypy


# Submission 폴더 파일 실행
cd submission || { echo "[INFO] submission 디렉토리로 이동 실패"; exit 1; }

for file in *.py; do
    ## TODO
    problem_number="${file#*_}"
    problem_number="${problem_number%.py}"

    input_file="../input/${problem_number}_input"
    output_file="../output/${problem_number}_output"

    if [ -f "$input_file" ]; then
        echo "[INFO] ${file} 실행"
        python "$file" < "$input_file" > "$output_file"
    else
        echo "[INFO] 입력 파일 없음: ${input_file}"
    fi
done

# mypy 테스트 실행 및 mypy_log.txt 저장
## TODO
python -m mypy *.py > ../mypy_log.txt 2>&1

# conda.yml 파일 생성
## TODO
conda env export > ../conda.yml

# 가상환경 비활성화
## TODO
conda deactivate