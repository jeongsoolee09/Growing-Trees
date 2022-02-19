import { Branch } from './branch.js';

export class Tree {
	constructor(ctx, posX, posY) {
		this.ctx = ctx;
		this.posX = posX;
		this.posY = posY;
		this.branches = [];
		this.depth = 11;

		this.cntDepth = 0; // depth별로 그리기 위해 현재 depth 변수 선언
		this.animation = null; // 현재 동작하는 애니메이션

		this.init();
	}

	init() {
		// depth별로 가지를 저장하기 위해 branches에 depth만큼 빈배열 추가
		for (let i = 0; i < this.depth; i++) {
			this.branches.push([]);
		}

		this.createBranch(this.posX, this.posY, -90, 0);
		this.draw();
	}

	randomInt(min, max) {
		min = Math.ceil(min);
		max = Math.floor(max);
		return Math.floor(Math.random() * (max - min) + min);
	}

	cos(x) {
		return Math.cos(x)
	}
	sin(x) {
		return Math.sin(x)
	}

	createBranch(startX, startY, angle, depth) {
		if (depth === this.depth) return;

		const len = depth === 0 ? this.randomInt(10, 13) : this.randomInt(0, 11);

		const endX = startX + Math.cos(angle) * len * (this.depth - depth);
		const endY = startY + Math.sin(angle) * len * (this.depth - depth);

		// depth에 해당하는 위치의 배열에 가지를 추가
		this.branches[depth].push(
			new Branch(startX, startY, endX, endY, this.depth - depth)
		);

		this.createBranch(endX, endY, angle - this.randomInt(15, 23), depth + 1);
		this.createBranch(endX, endY, angle + this.randomInt(15, 23), depth + 1);
	}

	draw() {
		// 다 그렸으면 requestAnimationFrame을 중단해 메모리 누수가 없게 함.
		if (this.cntDepth === this.depth) {
			cancelAnimationFrame(this.animation);
		}

		// depth별로 가지를 그리기
		for (let i = this.cntDepth; i < this.branches.length; i++) {
			let pass = true;

			for (let j = 0; j < this.branches[i].length; j++) {
				pass = this.branches[i][j].draw(this.ctx);
			}

			if (!pass) break;
			this.cntDepth++;
		}

		this.animation = requestAnimationFrame(this.draw.bind(this));
	}
}
