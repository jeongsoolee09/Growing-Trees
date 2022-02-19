import { Tree } from './tree.js';

class App {
    constructor() {
        this.canvas = document.createElement('canvas');
        document.body.appendChild(this.canvas);

        this.ctx = this.canvas.getContext('2d');
        this.pixelRatio = window.devicePixelRatio > 1 ? 2 : 1;

        // click이벤트 추가
        window.addEventListener('resize', this.resize.bind(this), false);
        window.addEventListener('click', this.click.bind(this), false);
        this.resize();
    }

    resize() {
        this.stageWidth = document.body.clientWidth;
        this.stageHeight = document.body.clientHeight;

        this.canvas.width = this.stageWidth * this.pixelRatio;
        this.canvas.height = this.stageHeight * this.pixelRatio;
        this.ctx.scale(this.pixelRatio, this.pixelRatio);

        this.ctx.clearRect(0, 0, this.stageWidth, this.stageHeight);
    }

    // click 함수 추가
    click(event) {
        const { clientX } = event;
        new Tree(this.ctx, clientX, this.stageHeight);
    }
}

window.onload = () => {
    new App();
};
